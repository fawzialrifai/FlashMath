//
//  Game.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 31/05/2022.
//

import SwiftUI
import Combine

@MainActor class Game: ObservableObject {
    @Published var cards = [Card]()
    var exambleCards = [Card]()
    @Published var timeRemaining = 60
    @Published var status = GameStatus.stopped
    @Published var isAlertPresented = false
    @Published var isSettingsPresented = false
    @Published var isNegativesAllowed = true
    var timer = Timer.publish(every: 1, on: .main, in: .common)
    var timerSubscription: Cancellable?
    var speechRecognizer = SpeechRecognizer()
    var speechRecognizerSubscription: AnyCancellable?
    var operations: [Operation] = [.addition, .subtraction, .multiplication, .division]
    var allowedNumbers: [Int] {
        if isNegativesAllowed {
            return Array(-10 ... 10)
        } else {
            return Array(0 ... 10)
        }
    }
    var allowedDenominators: [Int] {
        if isNegativesAllowed {
            return Array(-10 ... -1) + Array(1 ... 10)
        } else {
            return Array(1 ... 10)
        }
    }
    init() {
        resetCards()
        resetExampleCards()
        speechRecognizerSubscription = speechRecognizer.$transcript.sink {
            self.speak($0)
        }
    }
    
    func removeOperation(_ operation: Operation) {
        if let index = operations.firstIndex(of: operation) {
            operations.remove(at: index)
            stop()
        }
    }
    
    func addOperation(_ operation: Operation) {
        operations.append(operation)
        stop()
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
            timeRemaining -= 1
        } else {
            end()
        }
    }
    
    func moveCard(from offsets: IndexSet, to index: Int) {
        cards.move(fromOffsets: offsets, toOffset: index)
    }
    
    func indexFor(_ card: Card) -> Int? {
        cards.firstIndex(of: card)
    }
    
    func moveCardUp(_ card: Card) {
        if let index = cards.firstIndex(of: card) {
            cards.move(fromOffsets: [index], toOffset: 0)
            speechRecognizer.clearTranscript()
        }
    }
    
    func moveCardDown(_ card: Card) {
        if let index = cards.firstIndex(of: card) {
            cards.move(fromOffsets: [index], toOffset: cards.count)
            speechRecognizer.clearTranscript()
        }
    }
    
    func start() {
        if speechRecognizer.isAuthorized {
            UISelectionFeedbackGenerator().selectionChanged()
            timer = Timer.publish(every: 1, on: .main, in: .common)
            timerSubscription = timer.connect()
            status = .started
            speechRecognizer.transcribe()
        } else {
            isAlertPresented = true
        }
    }
    
    func pause() {
        UISelectionFeedbackGenerator().selectionChanged()
        status = .paused
        timerSubscription?.cancel()
        speechRecognizer.stopTranscribing()
    }
    
    func stop() {
        UISelectionFeedbackGenerator().selectionChanged()
        resetCards()
        timeRemaining = 60
        status = .paused
        timerSubscription?.cancel()
        speechRecognizer.stopTranscribing()
    }
    
    func restart() {
        resetCards()
        timeRemaining = 60
        start()
    }
    
    func end() {
        timerSubscription?.cancel()
        speechRecognizer.stopTranscribing()
        status = .over
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
                let operation = operations.randomElement()!
                cards.append(getRandomCard(for: operation, from: allowedNumbers))
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

enum GameStatus {
    case started, paused, stopped, over
}
