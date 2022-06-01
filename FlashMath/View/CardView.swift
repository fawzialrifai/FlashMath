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
            VStack(spacing: 8) {
                Text(card.question)
                    .font(.largeTitle.bold())
                if game.status == .over {
                    Text(card.correctAnswer, format: .number)
                        .font(.title)
                } else {
                    if let answer = card.answer {
                        Text(answer, format: .number)
                            .font(.title)
                    } else {
                        Image(systemName: "waveform")
                            .font(.title)
                    }
                }
            }
            .foregroundColor(card.answer == nil ? .black : .white)
            .animation(nil, value: game.status)
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
                    if abs(offset.width) > 200 || offset.height > 200 {
                        withAnimation {
                            game.moveCardDown(card)
                        }
                    } else if offset.height < -200 {
                        withAnimation {
                            game.moveCardUp(card)
                        }
                    }
                    offset = .zero
                }
        )
        .animation(.spring(), value: offset)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: .example)
            .previewLayout(.sizeThatFits)
            .environmentObject(Game())
    }
}
