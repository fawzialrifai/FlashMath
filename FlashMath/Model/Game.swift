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
    @Published var timeRemaining = 60
    @Published var status = GameStatus.stopped
    @Published var isAlertPresented = false
    var timer = Timer.publish(every: 1, on: .main, in: .common)
    var timerSubscription: Cancellable?
    var speechRecognizer = SpeechRecognizer()
    var speechRecognizerSubscription: AnyCancellable?
    
    init() {
        resetCards()
        speechRecognizerSubscription = speechRecognizer.$transcript.sink {
            self.speak($0)
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
    
    func resetCards() {
        cards = []
        for _ in 1 ... 10 {
            let firstNumber = Int.random(in: 2...9)
            let secondNumber = Int.random(in: 2...9)
            let card = Card(firstNumber: firstNumber, secondNumber: secondNumber, operation: Operation.allCases.randomElement()!)
            cards.append(card)
        }
    }
}

enum GameStatus {
    case started, paused, stopped, over
}
