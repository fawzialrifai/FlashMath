//
//  CardView.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 28/05/2022.
//

import SwiftUI

struct CardView: View {
    @State var card: Card
    var speechTranscript: Int?
    let isCorrectAnswerShown: Bool
    let onDrag: (() -> Void)
    @State private var offset = CGSize.zero
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(card.answer == nil ? .white : card.answer == card.correctAnswer ? .blue : .red)
                .shadow(radius: 4)
            if card.answer != nil {
                if card.answer == card.correctAnswer {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title)
                        .padding()
                } else {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .padding()
                }
            }
            VStack {
                Text(card.question)
                    .font(.largeTitle.bold())
                if isCorrectAnswerShown {
                    Text(card.correctAnswer, format: .number)
                        .font(.title)
                } else {
                    if let answer = card.answer {
                        Text(answer, format: .number)
                            .font(.title)
                    } else {
                        Text("_")
                            .font(.title)
                    }
                }
            }
            .animation(nil, value: isCorrectAnswerShown)
            .foregroundColor(card.answer == nil ? .black : .white)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
        }
        .frame(width: 250, height: 200)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(offset)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { gesture in
                    if abs(offset.width) > 250 || offset.height > 200 {
                        onDrag()
                    }
                    offset = .zero
                }
        )
        .animation(.spring(), value: offset)
        .onChange(of: speechTranscript) { newValue in
            if newValue != nil {
                card.answer = newValue
            }
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: .example, isCorrectAnswerShown: false, onDrag: {})
            .previewLayout(.sizeThatFits)
            .previewInterfaceOrientation(.portrait)
    }
}
