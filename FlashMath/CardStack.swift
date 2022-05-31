//
//  CardStack.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 28/05/2022.
//

import SwiftUI
import Combine

struct CardStack: View {
    @State private var cards = [Card]()
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var cancellableTimer: Cancellable? = nil
    @State private var timeRemaining = 60
    @StateObject var speechRecognizer = SpeechRecognizer()
    @Environment(\.scenePhase) var scenePhase
    @State private var gameStatus = GameStatus.stopped
    @State private var isAlertPresented = false
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 32) {
                Button(action: stopGame) {
                    Image(systemName: "stop.fill")
                }
                ProgressView(value: Double(timeRemaining), total: 60)
                    .progressViewStyle(GaugeProgressStyle())
                    .frame(width: 22, height: 22)
                if gameStatus == .started {
                    Button(action: pauseGame) {
                        Image(systemName: "pause.fill")
                    }
                } else {
                    if gameStatus == .over {
                        Button(action: restartGame) {
                            Image(systemName: "play.fill")
                                .scaleEffect(CGSize(width: -1.0, height: 1.0))
                        }
                    } else {
                        Button(action: playGame) {
                            Image(systemName: "play.fill")
                        }
                    }
                }
            }
            .tint(.primary)
            .font(.largeTitle)
            .padding()
            .padding()
            ZStack {
                ForEach(Array(cards.enumerated()), id: \.element) { item in
                    CardView(card: item.element, isCorrectAnswerShown: gameStatus == .over ? true : false) {
                        withAnimation {
                            moveCard(from: [item.offset], to: cards.count)
                        }
                    } onDragDown: {
                        withAnimation {
                            moveCard(from: [item.offset], to: 0)
                        }
                    }
                    .stacked(at: item.offset, in: cards.count)
                }
            }
            Spacer()
            Spacer()
        }
        .padding()
        .preferredColorScheme(.dark)
        .onAppear(perform: resetCards)
        .onReceive(timer) { time in
            guard gameStatus == .started && scenePhase == .active else { return }
            if timeRemaining > 0 {
                withAnimation(Animation.linear(duration: 1)) {
                    timeRemaining -= 1
                }
            } else {
                endGame()
            }
        }
        .onChange(of: scenePhase) { _ in
            if scenePhase == .active {
                if gameStatus == .started {
                    speechRecognizer.stopTranscribing()
                }
            } else {
                if gameStatus == .started {
                    speechRecognizer.transcribe()
                }
            }
        }
        .onChange(of: speechRecognizer.transcript) { newValue in
            let isAnswerCorrect = cards[cards.count - 1].updateAnswer(with: newValue)
            if isAnswerCorrect {
                if cards.allSatisfy({ $0.answer == $0.correctAnswer }) {
                    endGame()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if gameStatus == .started {
                    speechRecognizer.restart()
                }
            }
        }
        .alert("Cannot Access the Microphone or Speech Recognization", isPresented: $isAlertPresented) {
            Button("OK") {}
        } message: {
            Text("Please allow FlashMath access the microphone and speech recognization from Settings.")
        }
    }
    
    func moveCard(from offsets: IndexSet, to index: Int) {
        cards.move(fromOffsets: offsets, toOffset: index)
        speechRecognizer.clearTranscript()
    }
    
    func playGame() {
        if speechRecognizer.isAuthorized {
            UISelectionFeedbackGenerator().selectionChanged()
            gameStatus = .started
            timer = Timer.publish(every: 1, on: .main, in: .common)
            cancellableTimer = timer.connect()
            speechRecognizer.transcribe()
        } else {
            isAlertPresented = true
        }
    }
    
    func pauseGame() {
        UISelectionFeedbackGenerator().selectionChanged()
        gameStatus = .paused
        cancellableTimer?.cancel()
        speechRecognizer.stopTranscribing()
    }
    
    func stopGame() {
        UISelectionFeedbackGenerator().selectionChanged()
        resetCards()
        timeRemaining = 60
        gameStatus = .paused
        cancellableTimer?.cancel()
        speechRecognizer.stopTranscribing()
    }
    
    func restartGame() {
        resetCards()
        timeRemaining = 60
        playGame()
    }
    
    func endGame() {
        cancellableTimer?.cancel()
        speechRecognizer.stopTranscribing()
        gameStatus = .over
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CardStack()
        
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 20)
    }
}

enum GameStatus {
    case started, paused, stopped, over
}
