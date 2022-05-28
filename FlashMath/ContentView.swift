//
//  ContentView.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 28/05/2022.
//

import SwiftUI

struct ContentView: View {
    @State private var cards = [Card]()
    @State private var isEditCardsPresented = false
    @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var timeRemaining = 30
    @Environment(\.scenePhase) var scenePhase
    @State private var isGameActive = false
    var body: some View {
        ZStack(alignment: .top) {
            Color.black
                .ignoresSafeArea()
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
                    ForEach(cards.reversed()) { card in
                        let index = cards.firstIndex(of: card)!
                        CardView(card: card) {
                            withAnimation {
                                removeCard()
                            }
                        } onAnsweringIncorrectly: {
                            withAnimation {
                                moveCard()
                            }
                        }
                        .stacked(at: index)
                        .allowsHitTesting(index == 0)
                        .accessibilityHidden(index > 0)
                    }
                }
                .allowsHitTesting(timeRemaining > 0 && isGameActive)
                Spacer()
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .onAppear(perform: setupQuestions)
        .onReceive(timer) { time in
            guard isGameActive && scenePhase == .active && !isEditCardsPresented && !cards.isEmpty else { return }
            if timeRemaining > 0 {
                withAnimation(Animation.linear(duration: 1)) {
                    timeRemaining -= 1
                }
            } else {
                timer.upstream.connect().cancel()
                isGameActive = false
            }
        }
    }
    
    func setupQuestions() {
        for _ in 1 ... 15 {
            let firstNumber = Int.random(in: 2...9)
            let secondNumber = Int.random(in: 2...9)
            let card = Card(question: "\(firstNumber) × \(secondNumber)", answer: String(firstNumber * secondNumber))
            cards.append(card)
        }
    }
        
    func removeCard() {
        cards.remove(at: 0)
        if cards.isEmpty {
            isGameActive = false
        }
    }
    
    func moveCard() {
        cards.move(fromOffsets: [0], toOffset: cards.count)
    }
    
    func restartGame() {
        resetCards()
        resetTime()
        playGame()
    }
    
    func stopGame() {
        UISelectionFeedbackGenerator().selectionChanged()
        resetCards()
        timeRemaining = 30
        isGameActive = false
        timer.upstream.connect().cancel()
    }
    
    func resetTime() {
        timeRemaining = 30
    }
    
    func resetCards() {
        cards = []
        setupQuestions()
    }
    
    func pauseGame() {
        UISelectionFeedbackGenerator().selectionChanged()
        isGameActive = false
        timer.upstream.connect().cancel()
    }
    
    func playGame() {
        UISelectionFeedbackGenerator().selectionChanged()
        isGameActive = true
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}

extension View {
    func stacked(at position: Int) -> some View {
        let offset = Double(position)
        return self.offset(x: 0, y: offset * 15)
    }
}
