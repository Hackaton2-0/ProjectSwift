//
//  ContentLevek.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 08/03/25.
//

import SwiftUI
import AVKit

struct ContentView: View {
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    private let xOffsets: [CGFloat] = [0, -40, -60, -40, 0]
    private let icons: [String] = [
        "1.circle.fill",
        "2.circle.fill",
        "3.circle.fill",
        "4.circle.fill",
        "5.circle.fill"
    ]
    
    @State var score: Int = 0
    @State private var showGameView = false
    @StateObject var gameData = GameData()
    @State private var floating = false
    @State private var levelStars: [Int] = Array(repeating: 0, count: 5)
    @State private var showLevelOne = false
    @State private var showNoLivesPopup = false
    @State private var showHeartShop = false
    @State private var contentReturn = true
    @Binding var isPressented: Bool

    var body: some View {
        ZStack {
            Image("vistageneral")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                ZStack{
                    Text("Section 1: Rookie")
                        .font(.title3)
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.6))
                        //.offset(y: -10)
                    
                    Button(action: {
                        isPressented = false
                    }) {
                        Image(systemName: "arrowshape.turn.up.left")
                            .font(.title2.bold())
                            .frame(width: 30, height: 10)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                    }
                    .position(x: UISW * 0.06, y: UISH * 0.02)
                }
                ForEach(0..<xOffsets.count, id: \.self) { index in
                    VStack() {
                        Button {
                            if index == 0 {
                                if gameData.lives > 0 {
                                    showLevelOne = true
                                } else {
                                    showNoLivesPopup = true
                                }
                            }
                        } label: {
                            Image(systemName: icons[index])
                                .resizable()
                                .frame(width: 85, height: 85)
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(.white)
                        }
                        .buttonStyle(
                            DepthButtonStyle(
                                fooregroundColor: Color(red: 0.2, green: 0.5, blue: 0.2),
                                backgroundColor: Color(red: 0.6, green: 0.4, blue: 0.2)
                            )
                        )
                        .frame(width: 150, height: 140)
                        .padding()
                        .offset(y: floating ? -5 : 5)
                        .animation(.easeInOut(duration: 1.5).repeatForever(), value: floating)
                        
                        HStack(spacing: 4) {
                            ForEach(0..<3) { starIndex in
                                Image(systemName: starIndex < levelStars[index] ? "star.fill" : "star")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(starIndex < levelStars[index] ? .red : .black)
                                    .offset(y: floating ? -5 : 5)
                                    .animation(.easeInOut(duration: 1.5).repeatForever(), value: floating)
                            }
                        }
                    }
                    .offset(x: xOffsets[index])
                }
                
                rectangleButton()
                
                Spacer()
            }
            ScoreView()
                .environmentObject(gameData)
                .offset(x: 260, y: -550)

            if showHeartShop {
                HeartShopView(isPresented: $showHeartShop)
                    .environmentObject(gameData)
                    .position(x: UISW / 2, y: UISH / 2)
            }
            
            if showNoLivesPopup {
                VStack(spacing: 16) {
                    Text("¡Sin vidas!")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("No tienes vidas suficientes. ¿Deseas comprar vidas?")
                        .multilineTextAlignment(.center)

                    HStack(spacing: 20) {
                        Button("Cancelar") {
                            showNoLivesPopup = false
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("Ir a tienda") {
                            showNoLivesPopup = false
                            showHeartShop = true
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
            }
            
        }
        .onAppear {
            playBackgroundSound(sound: .IntroCumbia, fadeOutPrevious: true)
            floating.toggle()
        }
        .fullScreenCover(isPresented: $showLevelOne) {
            LevelOneView(
                onFinish: { estrellas in
                    levelStars[0] = estrellas
                },
                contentReturn: $contentReturn,
                isPresented: $showLevelOne
            )
            .environmentObject(gameData)
        }

        .fullScreenCover(isPresented: $showGameView) {
            GameView(isPresented: $showGameView).environmentObject(gameData)
        }
        .environmentObject(gameData)
    }
    
    @ViewBuilder
    private func ellipseButton(image: String, index: Int) -> some View {
        Button(action: {
            if index == 0 {
                showLevelOne = true
            } else {
                
            }
        }, label: {
            Image(systemName: image)
                .resizable()
                .frame(width: 85, height: 85)
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.white)
        })
        .buttonStyle(
            DepthButtonStyle(
                fooregroundColor: Color(red: 0.2, green: 0.5, blue: 0.2),
                backgroundColor: Color(red: 0.6, green: 0.4, blue: 0.2))
        )
        .frame(width: 150, height: 140)
        .padding()
        .offset(y: floating ? -5 : 5)
        .animation(.easeInOut(duration: 1.5).repeatForever(), value: floating)
        
    }
    
    @ViewBuilder
    private func rectangleButton() -> some View {
        Button {
            showGameView = true
        } label: {
            Text("Bonus")
                .fontWeight(.semibold)
                .foregroundStyle(Color.black)
        }
        .buttonStyle(DepthButtonStyle(fooregroundColor: .red, backgroundColor: .red, cornerRadius: 20))
        .frame(width: 250, height: 50)
    }
}

#Preview {
    ContentView(score: 0, isPressented: .constant(true))
}
