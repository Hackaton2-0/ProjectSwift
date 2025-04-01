//
//  CardView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 31/03/25.
//

import SwiftUI

struct CardView: View {
    @ObservedObject var card: Card
    let width: Int

    @Binding var MatchedCards: [Card]
    @Binding var userChoices: [Card]

    @State private var flipped = false
    @State private var rotation: Double = 0

    var body: some View {
        ZStack {
            if card.isFaceUP || MatchedCards.contains(where: { $0.id == card.id }) {
                Image(card.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: CGFloat(width), height: CGFloat(width))
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 0.18, green: 0.32, blue: 0.46), lineWidth: 5)
                    )
            } else {
                Image("?")
                    .resizable()
                    .scaledToFit()
                    .frame(width: CGFloat(width), height: CGFloat(width))
                    .background(Color(red: 0.68, green: 0.83, blue: 0.96))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 0.18, green: 0.32, blue: 0.46), lineWidth: 5)
                    )
                    .onTapGesture {
                        handleTap()
                    }
            }
        }
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
        .animation(.easeInOut(duration: 0.4), value: rotation)
    }

    private func handleTap() {
        if userChoices.count == 0 {
            flipCard()
            userChoices.append(card)
        } else if userChoices.count == 1 {
            flipCard()
            userChoices.append(card)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    for thisCard in userChoices {
                        thisCard.tunrOver()
                    }
                }
                checkForMatch()
            }
        }
    }

    private func flipCard() {
        withAnimation {
            rotation += 180
            card.tunrOver()
        }
    }

    private func checkForMatch() {
        if userChoices.count == 2 {
            if userChoices[0].imageName == userChoices[1].imageName {
                MatchedCards.append(userChoices[0])
                MatchedCards.append(userChoices[1])
            }
            userChoices.removeAll()
        }
    }
}
