//
//  CardStack.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 28/05/2022.
//

import SwiftUI

struct CardStack: View {
    @StateObject var game = Game()
    @Environment(\.scenePhase) var scenePhase
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 32) {
                Button {
                    game.stop()
                } label: {
                    Image(systemName: "stop.fill")
                }
                ProgressView(value: Double(game.timeRemaining), total: 60)
                    .progressViewStyle(CircleProgressStyle())
                    .frame(width: 22, height: 22)
                    .animation(.linear(duration: 1), value: game.timeRemaining)
                if game.status == .started {
                    Button {
                        game.pause()
                    } label: {
                        Image(systemName: "pause.fill")
                    }
                } else {
                    if game.status == .over {
                        Button {
                            game.restart()
                        } label: {
                            Image(systemName: "play.fill")
                                .scaleEffect(CGSize(width: -1.0, height: 1.0))
                        }
                    } else {
                        Button {
                            game.start()
                        } label: {
                            Image(systemName: "play.fill")
                        }
                    }
                }
            }
            .tint(.primary)
            .font(.largeTitle)
            .padding()
            ZStack {
                ForEach(game.cards.reversed()) { card in
                    CardView(card: card)
                        .offset(x: 0, y: CGFloat(game.indexFor(card)) * 20)
                        .environmentObject(game)
                }
            }
            Spacer()
            Spacer()
        }
        .padding()
        .preferredColorScheme(.dark)
        .onChange(of: scenePhase) { newValue in
            if newValue == .active {
                if game.status == .started {
                    game.speechRecognizer.transcribe()
                }
            } else {
                if game.status == .started {
                    game.speechRecognizer.stopTranscribing()
                }
            }
        }
        .onReceive(game.timer, perform: { _ in
            if scenePhase == .active {
                game.updateTime()
            }
        })
        .alert("Cannot Access the Microphone or Speech Recognization", isPresented: $game.isAlertPresented) {
            Button("OK") {}
        } message: {
            Text("Please allow FlashMath access the microphone and speech recognization from Settings.")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CardStack()
    }
}
