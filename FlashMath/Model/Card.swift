//
//  Card.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 28/05/2022.
//

import SwiftUI

struct Card: Identifiable, Hashable {
    var id = UUID()
    let firstNumber: Int
    let secondNumber: Int
    let operation: Operation
    var answer: Int? = nil
    var question: String { "\(firstNumber) \(operation.rawValue) \(secondNumber)" }
    var correctAnswer: Int {
        switch operation {
        case .addition:
            return firstNumber + secondNumber
        case .subtraction:
            return firstNumber - secondNumber
        case .multiplication:
            return firstNumber * secondNumber
        case .Division:
            return firstNumber / secondNumber
        }
    }
    mutating func updateAnswer(with newAnswer: String) -> Bool {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        if let number = Int(newAnswer.lowercased()) {
            answer = number
        } else if let number = numberFormatter.number(from: newAnswer.lowercased()) {
            answer = Int(truncating: number)
        }
        if answer == correctAnswer {
            return true
        } else {
            return false
        }
    }
    var color: Color {
        if answer == nil {
            return .white
        } else {
            if answer == correctAnswer {
                return .blue
            } else {
                return .red
            }
        }
    }
    static let example = Card(firstNumber: 2, secondNumber: 3, operation: .addition)
}

enum Operation: String, CaseIterable {
    case addition = "+"
    case subtraction = "−"
    case multiplication = "×"
    case Division = "÷"
}
