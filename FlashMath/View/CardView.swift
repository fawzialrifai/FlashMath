//
//  CardView.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 28/05/2022.
//

import SwiftUI

struct CardView: View {
    @EnvironmentObject var game: Game
    let card: Card
    @State private var offset = CGSize.zero
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(card.color)
                .shadow(radius: 4)
            if game.status == .started && game.indexFor(card) == 0 && !game.isSettingsPresented {
                MultiWave(color: card.answer == nil ? .black.opacity(0.25) : .white.opacity(0.25))
            }
            VStack(spacing: 8) {
                Text(card.question)
                    .font(.largeTitle.bold())
                Group {
                    if game.status == .started {
                        if let answer = card.answer {
                            Text(answer, format: .number)
                        } else if game.indexFor(card) == 0 && !game.isSettingsPresented {
                            Text("Answer")
                                .foregroundColor(.black.opacity(0.25))
                        }
                    } else if game.status == .paused {
                        if let answer = card.answer {
                            Text(answer, format: .number)
                        }
                    } else if game.status == .over {
                        Text(card.correctAnswer, format: .number)
                    }
                }
                .font(.title)
            }
            .foregroundColor(card.answer == nil ? .black : .white)
        }
        .frame(width: 250, height: 200)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    if abs(offset.width) > 200 || offset.height > 200 {
                        game.moveCardDown(card)
                        game.speechRecognizer.clearTranscript()
                    } else if offset.height < -200 {
                        game.moveCardUp(card)
                        game.speechRecognizer.clearTranscript()
                    }
                    offset = .zero
                }
        )
        .onChange(of: card.answer) { answer in 
            if answer == card.correctAnswer {
                UINotificationFeedbackGenerator().notificationOccurred(.success)
            } else {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
            }
        }
        .animation(.spring(), value: offset)
        .animation(.default, value: game.status)
        .animation(.spring(), value: game.cards)
        .animation(.default, value: game.isSettingsPresented)
    }
    
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: .example)
            .previewLayout(.sizeThatFits)
            .environmentObject(Game())
    }
}
