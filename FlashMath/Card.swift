//
//  Card.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 28/05/2022.
//

import Foundation

struct Card: Identifiable, Codable, Equatable {
    var id = UUID()
    let firstNumber: Int
    let secondNumber: Int
    let product: Int
    var question: String {
        "\(firstNumber) × \(secondNumber)"
    }
    var answer: String {
        "\(product)"
    }
    
    //static let example = Card(question: "2 × 2", answer: "4")
}
