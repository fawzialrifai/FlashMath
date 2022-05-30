//
//  ContentView.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 28/05/2022.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var cards = [Card]()
    @State private var isEditCardsPresented = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common)
    @State private var cancellableTimer: Cancellable? = nil
    @State private var timeRemaining = 30
    @StateObject var speechRecognizer = SpeechRecognizer()
    @Environment(\.scenePhase) var scenePhase
    @State private var isGameActive = false
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                HStack(spacing: 32) {
                    Button(action: stopGame) {
                        Image(systemName: "stop.fill")
                    }
                    ProgressView(value: Double(timeRemaining), total: 30)
                        .progressViewStyle(GaugeProgressStyle())
                        .frame(width: 22, height: 22)
                    if isGameActive {
                        Button(action: pauseGame) {
                            Image(systemName: "pause.fill")
                        }
                    } else {
                        if timeRemaining == 0 || cards.isEmpty {
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
                        CardView(card: item.element, speechTranscript: item.offset == cards.count - 1 ? speechRecognizer.integerTranscript : nil, isCorrectAnswerShown: timeRemaining == 0 ? true : false) {
                            withAnimation {
                                moveCard()
                            }
                        }
                        .stacked(at: item.offset, in: cards.count)
                        .allowsHitTesting(item.offset == cards.count - 1)
                    }
                }
                Spacer()
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: resetCards)
        .onReceive(timer) { time in
            guard isGameActive && scenePhase == .active && !isEditCardsPresented && !cards.isEmpty else { return }
            if timeRemaining > 0 {
                withAnimation(Animation.linear(duration: 1)) {
                    timeRemaining -= 1
                }
            } else {
                cancellableTimer?.cancel()
                isGameActive = false
                speechRecognizer.stopTranscribing()
            }
        }
    }
    
    func moveCard() {
        cards.move(fromOffsets: [cards.count - 1], toOffset: 0)
        if isGameActive {
            speechRecognizer.stopTranscribing()
            speechRecognizer.transcribe()
        }
    }
    
    func playGame() {
        UISelectionFeedbackGenerator().selectionChanged()
        isGameActive = true
        timer = Timer.publish(every: 1, on: .main, in: .common)
        cancellableTimer = timer.connect()
        speechRecognizer.reset()
        speechRecognizer.transcribe()
    }
    
    func pauseGame() {
        UISelectionFeedbackGenerator().selectionChanged()
        isGameActive = false
        cancellableTimer?.cancel()
        speechRecognizer.pauseTranscribing()
    }
    
    func stopGame() {
        UISelectionFeedbackGenerator().selectionChanged()
        resetCards()
        timeRemaining = 30
        isGameActive = false
        cancellableTimer?.cancel()
        speechRecognizer.stopTranscribing()
    }
    
    func restartGame() {
        resetCards()
        timeRemaining = 30
        playGame()
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
        ContentView()
        
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 15)
    }
}
