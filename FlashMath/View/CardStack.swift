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
        ZStack {
            Color.black
                .ignoresSafeArea()
            VStack {
                Spacer()
                ControlButtons()
                    .padding()
                ZStack {
                    ForEach(game.cards.reversed()) { card in
                        CardView(card: card)
                            .offset(x: 0, y: CGFloat(game.indexFor(card) ?? 0) * 20)
                    }
                }
                Spacer()
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
        .environmentObject(game)
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
        .sheet(isPresented: $game.isSettingsPresented) {
            SettingsView()
                .environmentObject(game)
        }
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
