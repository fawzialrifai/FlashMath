//
//  ControlButtons.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 01/06/2022.
//

import SwiftUI

struct ControlButtons: View {
    @EnvironmentObject var game: Game
    var body: some View {
        HStack(spacing: 32) {
            Button {
                UISelectionFeedbackGenerator().selectionChanged()
                game.stop()
            } label: {
                Image(systemName: "stop")
            }
            Button {
                UISelectionFeedbackGenerator().selectionChanged()
                game.isSettingsPresented = true
            } label: {
                ProgressView(value: Double(game.timeRemaining), total: 60)
                    .progressViewStyle(CircleProgressStyle())
                    .frame(width: 26, height: 26)
            }
            if game.status == .started && !game.isSettingsPresented {
                Button {
                    UISelectionFeedbackGenerator().selectionChanged()
                    game.pause()
                } label: {
                    Image(systemName: "pause")
                }
            } else {
                if game.status == .over {
                    Button {
                        UISelectionFeedbackGenerator().selectionChanged()
                        game.restart()
                    } label: {
                        Image(systemName: "restart")
                    }
                } else {
                    Button {
                        UISelectionFeedbackGenerator().selectionChanged()
                        game.start()
                    } label: {
                        Image(systemName: "play")
                    }
                }
            }
        }
        .tint(.white)
        .font(.largeTitle.bold())
        .animation(.linear(duration: 1), value: game.timeRemaining)
        .animation(.default, value: game.isSettingsPresented)
        .animation(.default, value: game.status)
    }
}

struct ControlButtons_Previews: PreviewProvider {
    static var previews: some View {
        ControlButtons()
            .previewLayout(.sizeThatFits)
            .environmentObject(Game())
    }
}
