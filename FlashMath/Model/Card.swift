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
    var question: String {
        var formattedFirstNumber = String(firstNumber)
        var formattedSecondsNumber = String(secondNumber)
        if firstNumber < 0 {
            formattedFirstNumber = "−\(firstNumber * -1)"
        }
        if secondNumber < 0 {
            if operation == .addition || operation == .subtraction {
                formattedSecondsNumber = "(−\(secondNumber * -1))"
            } else {
                formattedSecondsNumber = "−\(secondNumber * -1)"
            }
        }
        return "\(formattedFirstNumber) \(operation.rawValue) \(formattedSecondsNumber)"
    }
    var correctAnswer: Int {
        switch operation {
        case .addition:
            return firstNumber + secondNumber
        case .subtraction:
            return firstNumber - secondNumber
        case .multiplication:
            return firstNumber * secondNumber
        case .division:
            return firstNumber / secondNumber
        }
    }
    mutating func updateAnswer(with newAnswer: String) -> Bool {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .spellOut
        numberFormatter.locale = Locale.current
        if let number = Int(newAnswer.lowercased()) {
            if answer != number {
                if number == correctAnswer {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            }
            answer = number
        } else if let number = numberFormatter.number(from: newAnswer.lowercased()) {
            if answer != Int(truncating: number) {
                if Int(truncating: number) == correctAnswer {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                } else {
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }
            }
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

enum Operation: String, CaseIterable, Codable {
    case addition = "+"
    case subtraction = "−"
    case multiplication = "×"
    case division = "÷"
    var name: String {
        switch self {
        case .addition:
            return "Addition"
        case .subtraction:
            return "Subtraction"
        case .multiplication:
            return "Multiplication"
        case .division:
            return "Division"
        }
    }
}
