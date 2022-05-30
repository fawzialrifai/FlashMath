//
//  Card.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 28/05/2022.
//

import Foundation

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
    static let example = Card(firstNumber: 2, secondNumber: 3, operation: .addition)
}

enum Operation: String, CaseIterable{
    case addition = "+"
    case subtraction = "−"
    case multiplication = "×"
    case Division = "÷"
}
