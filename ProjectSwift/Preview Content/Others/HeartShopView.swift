//
//  HeartShopView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 26/03/25.
//

import SwiftUI

struct HeartShopView: View {
    @EnvironmentObject var gameData: GameData
    @Binding var isPresented: Bool

    @State private var showConfirmPopup = false
    @State private var purchaseAmount = 0
    @State private var isPulsing = false


    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.cyan.opacity(0.2))
                .frame(width: 300, height: 230)
                .shadow(radius: 10)

            VStack(spacing: 20) {
                Text("Comprar Vidas")
                    .font(.title2.bold())
                    .padding()
                    .foregroundColor(Color.black)

                HStack(spacing: 25) {
                    Button {
                        confirmPurchase(amount: 1)
                    } label: {
                        heartOption(amount: 1, cost: 10)
                    }

                    Button {
                        confirmPurchase(amount: 3)
                    } label: {
                        heartOption(amount: 5, cost: 40)
                    }
                }
            }
            .padding()

            VStack {
                HStack {
                    Spacer()
                    Button {
                        isPresented = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.gray)
                            .padding()
                    }
                }
                Spacer()
            }
            .frame(width: 300, height: 230)
            .zIndex(2)

            if showConfirmPopup {
                confirmPopup()
                    .zIndex(3)
            }
        }
        .onAppear {
            isPulsing = true
        }

    }

    private func heartOption(amount: Int, cost: Int) -> some View {
        VStack {
            ZStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 45))
                    .scaleEffect(isPulsing ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isPulsing)


                Text("\(amount)")
                    .font(.custom("Bebas Neue", size: 25))
                    .foregroundColor(.white)
            }
            Text("\(cost) pts")
                .font(.custom("Bebas Neue", size: 25))
                .foregroundColor(.black)
        }
        .frame(width: 70)
    }


    private func confirmPurchase(amount: Int) {
        purchaseAmount = amount
        showConfirmPopup = true
    }

    private func confirmPopup() -> some View {
        VStack(spacing: 16) {
            Text("¿Comprar \(purchaseAmount) vida(s)?")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 20) {
                Button("No") {
                    showConfirmPopup = false
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(10)

                Button("Sí") {
                    let cost = purchaseAmount == 1 ? 15 : 70
                    let available = 5 - gameData.lives
                    let toAdd = min(purchaseAmount, available)
                    if gameData.score >= cost && toAdd > 0 {
                        gameData.lives += toAdd
                        gameData.score -= cost
                    }
                    showConfirmPopup = false
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
        .zIndex(1)
        .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    }
}


#Preview {
    StatefulPreviewWrapper(true) { isPresented in
        HeartShopView(isPresented: isPresented)
            .environmentObject(GameData())
    }
}


