//
//  SettingsView.swift
//  FlashMath
//
//  Created by Fawzi Rifai on 03/06/2022.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var game: Game
    var body: some View {
        NavigationView {
            Form {
                OperationSection(operation: .addition, card: game.exambleCards[0])
                OperationSection(operation: .subtraction, card: game.exambleCards[1])
                OperationSection(operation: .multiplication, card: game.exambleCards[2])
                OperationSection(operation: .division, card: game.exambleCards[3])
                NegativesSection(card: game.exambleCards[4])
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: dismiss.callAsFunction)
                }
            }
        }
    }
}

struct OperationSection: View {
    @EnvironmentObject var game: Game
    let operation: Operation
    let card: Card
    var body: some View {
        Section("") {
            CheckmarkToggle(title: operation.name, isOn: game.operations.contains(operation)) {
                game.toggleOperation(operation)
            }
            SettingsCard(card: card)
        }
    }
}

struct NegativesSection: View {
    @EnvironmentObject var game: Game
    let card: Card
    var body: some View {
        Section("") {
            CheckmarkToggle(title: "Negatives", isOn: game.isNegativesAllowed) {
                game.isNegativesAllowed.toggle()
                game.resetExampleCards()
                game.stop()
            }
            SettingsCard(card: card)
        }
    }
}

struct CheckmarkToggle: View {
    var title: String
    var isOn: Bool
    var action: () -> Void
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Button(action: action) {
                Image(systemName: isOn ? "checkmark.circle.fill" : "circle")
                    .font(.title3.bold())
                    .foregroundStyle(.white)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

struct SettingsCard: View {
    let card: Card
    var body: some View {
        VStack(spacing: 8) {
            Text(card.question)
                .font(.largeTitle.bold())
            Text("\(card.correctAnswer)")
                .font(.title)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .foregroundColor(.black)
        .background(.white)
        .listRowInsets(EdgeInsets())
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
            .environmentObject(Game())
    }
}
