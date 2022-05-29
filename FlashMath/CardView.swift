//
//  CardView.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 28/05/2022.
//

import SwiftUI

struct CardView: View {
    let card: Card
    var speechTranscript: Int? = nil
    let onAnsweringCorrectly: (() -> Void)
    let onDrag: (() -> Void)
    @State private var offset = CGSize.zero
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(speechTranscript == nil ? .white : card.product == speechTranscript ? .blue : .red)
                .shadow(radius: 4)
            if card.product == speechTranscript {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title)
                    .padding()
            } else {
                Image(systemName: "xmark.circle.fill")
                    .font(.title)
                    .padding()
            }
            VStack {
                Text(card.question)
                    .font(.largeTitle.bold())
                if let answer = speechTranscript {
                    Text(answer, format: .number)
                        .font(.title)
                } else {
                    Text("_")
                        .font(.title)
                }
            }
            .foregroundColor(speechTranscript == nil ? .black : .white)
            .padding()
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
        .transition(.scale)
        .onChange(of: speechTranscript, perform: { newValue in
            if card.product == newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    onAnsweringCorrectly()
                }
            }
        })
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(card: .example)
//            .previewLayout(.sizeThatFits)
//            .previewInterfaceOrientation(.portrait)
//    }
//}
