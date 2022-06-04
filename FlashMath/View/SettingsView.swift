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
            List {
                Section("") {
                    HStack {
                        Text("Addition")
                        Spacer()
                        Button {
                            if game.operations.contains(.addition) {
                                game.removeOperation(.addition)
                            } else {
                                game.addOperation(.addition)
                            }
                        } label: {
                            if game.operations.contains(.addition) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                
                            } else {
                                Image(systemName: "circle")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    SettingsCard(operation: .addition, card: game.exambleCards[0])
                        .listRowInsets(EdgeInsets())
                        .frame(height: 200)
                }
                Section {
                    HStack {
                        Text("Subtraction")
                        Spacer()
                        Button {
                            if game.operations.contains(.subtraction) {
                                game.removeOperation(.subtraction)
                            } else {
                                game.addOperation(.subtraction)
                            }
                        } label: {
                            if game.operations.contains(.subtraction) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                
                            } else {
                                Image(systemName: "circle")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    SettingsCard(operation: .subtraction, card: game.exambleCards[1])
                        .listRowInsets(EdgeInsets())
                        .frame(height: 200)
                }
                Section {
                    HStack {
                        Text("Multiplication")
                        Spacer()
                        Button {
                            if game.operations.contains(.multiplication) {
                                game.removeOperation(.multiplication)
                            } else {
                                game.addOperation(.multiplication)
                            }
                        } label: {
                            if game.operations.contains(.multiplication) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                
                            } else {
                                Image(systemName: "circle")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    SettingsCard(operation: .multiplication, card: game.exambleCards[2])
                        .listRowInsets(EdgeInsets())
                        .frame(height: 200)
                }
                Section {
                    HStack {
                        Text("Division")
                        Spacer()
                        Button {
                            if game.operations.contains(.division) {
                                game.removeOperation(.division)
                            } else {
                                game.addOperation(.division)
                            }
                        } label: {
                            if game.operations.contains(.division) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                
                            } else {
                                Image(systemName: "circle")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    SettingsCard(operation: .division, card: game.exambleCards[3])
                        .listRowInsets(EdgeInsets())
                        .frame(height: 200)
                }
                Section {
                    HStack {
                        Text("Negatives")
                        Spacer()
                        Button {
                            game.isNegativesAllowed.toggle()
                            game.resetExampleCards()
                            game.stop()
                        } label: {
                            if game.isNegativesAllowed {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.title3.bold())
                                    .foregroundStyle(.white)
                                
                            } else {
                                Image(systemName: "circle")
                                    .font(.title3.bold())
                                    .foregroundColor(.white)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    SettingsCard(operation: .division, card: game.exambleCards[4])
                        .listRowInsets(EdgeInsets())
                        .frame(height: 200)
                }
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .preferredColorScheme(.dark)
            .environmentObject(Game())
    }
}

struct SettingsCard: View {
    let operation: Operation
    let card: Card
    @EnvironmentObject var game: Game
    var body: some View {
        VStack(spacing: 8) {
            Text(card.question)
                .font(.largeTitle.bold())
            Text("\(card.correctAnswer)")
                .font(.title)
        }
        .foregroundColor(.black)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white)
    }
}
