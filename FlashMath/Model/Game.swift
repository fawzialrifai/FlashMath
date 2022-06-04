//
//  Game.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 31/05/2022.
//

import SwiftUI
import Combine

@MainActor class Game: ObservableObject {
    
    enum GameStatus {
        case started, paused, stopped, over
    }
    
    @Published var cards = [Card]()
    @Published var timeRemaining = 60
    @Published var status = GameStatus.stopped
    @Published var isAlertPresented = false
    @Published var isSettingsPresented = false
    @AppStorage("isNegativesAllowed") var isNegativesAllowed = true
    var timer = Timer.publish(every: 1, on: .main, in: .common)
    var timerSubscription: Cancellable?
    var speechRecognizer = SpeechRecognizer()
    var speechRecognizerSubscription: AnyCancellable?
    var exambleCards = [Card]()
    var operations: [Operation] = [.addition, .subtraction, .multiplication, .division] {
        didSet { setOperations() }
    }
    
    var allowedNumbers: [Int] {
        return isNegativesAllowed ? Array(-10 ... 10) : Array(0 ... 10)
    }
    
    var allowedDenominators: [Int] {
        return isNegativesAllowed ? Array(-10 ... -1) + Array(1 ... 10) : Array(1 ... 10)
    }
    
    init() {
        getOperations()
        resetCards()
        resetExampleCards()
        speechRecognizerSubscription = speechRecognizer.$transcript.sink {
            self.speak($0)
        }
    }
    
    func getOperations() {
        if let encodedOperations = UserDefaults.standard.data(forKey: "Operations") {
            if let decodedOperations = try? JSONDecoder().decode([Operation].self, from: encodedOperations) {
                operations = decodedOperations
            }
        }
    }
    
    func setOperations() {
        if let encodedOperations = try? JSONEncoder().encode(operations) {
            UserDefaults.standard.set(encodedOperations, forKey: "Operations")
        }
    }
    
    func toggleOperation(_ operation: Operation) {
        if operations.contains(operation) {
            if let index = operations.firstIndex(of: operation) {
                operations.remove(at: index)
            }
        } else {
            operations.append(operation)
        }
    }
    
    func speak(_ transcript: String) {
        let isAnswerCorrect = cards[0].updateAnswer(with: transcript)
        if isAnswerCorrect {
            if cards.allSatisfy({ $0.answer == $0.correctAnswer }) {
                end()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.status == .started {
                self.speechRecognizer.restart()
            }
        }
    }
    
    func updateTime() {
        if timeRemaining > 0 {
            if !isSettingsPresented {
                timeRemaining -= 1
            }
        } else {
            end()
        }
    }
    
    func indexFor(_ card: Card) -> Int? {
        cards.firstIndex(of: card)
    }
    
    func moveCardUp(_ card: Card) {
        if let index = cards.firstIndex(of: card) {
            cards.move(fromOffsets: [index], toOffset: 0)
        }
    }
    
    func moveCardDown(_ card: Card) {
        if let index = cards.firstIndex(of: card) {
            cards.move(fromOffsets: [index], toOffset: cards.count)
        }
    }
    
    func start() {
        if speechRecognizer.isAuthorized {
            timer = Timer.publish(every: 1, on: .main, in: .common)
            timerSubscription = timer.connect()
            status = .started
            speechRecognizer.transcribe()
        } else {
            isAlertPresented = true
        }
    }
    
    func pause() {
        status = .paused
        timerSubscription?.cancel()
        speechRecognizer.stopTranscribing()
    }
    
    func stop() {
        status = .paused
        resetCards()
        timeRemaining = 60
        timerSubscription?.cancel()
        speechRecognizer.stopTranscribing()
    }
    
    func end() {
        status = .over
        timerSubscription?.cancel()
        speechRecognizer.stopTranscribing()
    }
    
    func restart() {
        resetCards()
        timeRemaining = 60
        start()
    }
    
    func getRandomCard(for operation: Operation, from allowedNumbers: [Int]) -> Card {
        let firstNumber = allowedNumbers.randomElement()!
        var secondNumber: Int
        if operation == .division {
            secondNumber = allowedDenominators.randomElement()!
        } else {
            secondNumber = allowedNumbers.randomElement()!
        }
        if operation == .subtraction && !isNegativesAllowed {
            while firstNumber - secondNumber < 0 {
                secondNumber = allowedNumbers.randomElement()!
            }
        }
        return Card(firstNumber: firstNumber, secondNumber: secondNumber, operation: operation)
    }
    
    func resetCards() {
        cards = []
        if operations.count > 0 {
            for _ in 1 ... 10 {
                if let operation = operations.randomElement() {
                    cards.append(getRandomCard(for: operation, from: allowedNumbers))
                }
            }
        }
    }
    
    func resetExampleCards() {
        exambleCards = []
        exambleCards.append(getRandomCard(for: .addition, from: allowedNumbers))
        exambleCards.append(getRandomCard(for: .subtraction, from: allowedNumbers))
        exambleCards.append(getRandomCard(for: .multiplication, from: allowedNumbers))
        exambleCards.append(getRandomCard(for: .division, from: allowedNumbers))
        exambleCards.append(getRandomCard(for: .addition, from: Array(-10 ... -1)))
    }
    
}
