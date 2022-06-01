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
        .tint(.white)
        .font(.largeTitle)
    }
}

struct ControlButtons_Previews: PreviewProvider {
    static var previews: some View {
        ControlButtons()
            .previewLayout(.sizeThatFits)
            .environmentObject(Game())
    }
}
