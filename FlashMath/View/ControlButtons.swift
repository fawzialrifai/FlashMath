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
                Image(systemName: "stop")
                    
            }
            ProgressView(value: Double(game.timeRemaining), total: 60)
                .progressViewStyle(CircleProgressStyle())
                .frame(width: 26, height: 26)
                .animation(.linear(duration: 1), value: game.timeRemaining)
            if game.status == .started {
                Button {
                    game.pause()
                } label: {
                    Image(systemName: "pause")
                }
            } else {
                if game.status == .over {
                    Button {
                        game.restart()
                    } label: {
                        Image(systemName: "restart")
                    }
                } else {
                    Button {
                        game.start()
                    } label: {
                        Image(systemName: "play")
                    }
                }
            }
        }
        .tint(.white)
        .font(.largeTitle.bold())
    }
}

struct ControlButtons_Previews: PreviewProvider {
    static var previews: some View {
        ControlButtons()
            .previewLayout(.sizeThatFits)
            .environmentObject(Game())
    }
}
