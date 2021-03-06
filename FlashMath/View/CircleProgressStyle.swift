//
//  CircleProgressStyle.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 28/05/2022.
//

import SwiftUI

struct CircleProgressStyle: ProgressViewStyle {
    var strokeColor = Color.white
    var strokeWidth = 4.0
    
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        return ZStack {
            Circle()
                .stroke(strokeColor.opacity(0.25), style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
            Circle()
                .trim(from: 0, to: fractionCompleted)
                .stroke(strokeColor, style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
    }
}

struct CircleProgressStyle_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView(value: Double(45), total: 60)
            .progressViewStyle(CircleProgressStyle())
    }
}
