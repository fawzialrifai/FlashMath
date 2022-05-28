//
//  CardView.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 28/05/2022.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var onAnsweringCorrectly: (() -> Void)? = nil
    var onAnsweringIncorrectly: (() -> Void)? = nil
    @State private var isAnswerPresented = false
    @State private var offset = CGSize.zero
    @State private var feedback = UINotificationFeedbackGenerator()
    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityVoiceOverEnabled) var voiceOverEnabled
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    differentiateWithoutColor
                    ? Color(uiColor: .secondarySystemGroupedBackground)
                    : Color(red: 0.9, green: 0.9, blue: 0.9)
                        .opacity(1 - Double(abs(offset.width / 100)))
                )
                .background(
                    differentiateWithoutColor
                    ? nil
                    : RoundedRectangle(cornerRadius: 20)
                        .fill(
                            offset.width == 0 ? Color(uiColor: .secondarySystemGroupedBackground)
                            : offset.width >= 0 ? .blue : .red
                        )
                )
                .shadow(radius: 4)
            Image(systemName: "checkmark.circle.fill")
                .font(.title)
                .padding()
                .opacity(Double((offset.width / 100)))
            Image(systemName: "xmark.circle.fill")
                .font(.title)
                .padding()
                .opacity(-Double((offset.width / 100)))
            VStack {
                if voiceOverEnabled {
                    Text(isAnswerPresented ? card.answer : card.question)
                        .font(.largeTitle.bold())
                } else {
                    Text(card.question)
                        .font(.largeTitle.bold())
                    if isAnswerPresented {
                        Text(card.answer)
                            .font(.title)
                    }
                }
            }
            .foregroundColor(Color(red: abs(offset.width) / 100.0, green: abs(offset.width) / 100.0, blue: abs(offset.width) / 100.0))
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .multilineTextAlignment(.center)
        }
        .frame(width: 250, height: 200)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 1.5, y: 0)
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                    feedback.prepare()
                }
                .onEnded { gesture in
                    if abs(offset.width) > 100 {
                        if offset.width > 0 {
                            feedback.notificationOccurred(.success)
                            onAnsweringCorrectly?()
                        } else {
                            feedback.notificationOccurred(.error)
                            onAnsweringIncorrectly?()
                            offset = .zero
                            isAnswerPresented = false
                        }
                    } else {
                        offset = .zero
                    }
                }
        )
        .onTapGesture {
            UISelectionFeedbackGenerator().selectionChanged()
            withAnimation {
                isAnswerPresented.toggle()
            }
        }
        .animation(.spring(), value: offset)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(card: .example)
            .previewLayout(.sizeThatFits)
            .previewInterfaceOrientation(.portrait)
    }
}
