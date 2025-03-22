//
//  ShootView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 12/03/25.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameData: GameData
    @Binding var isPresented: Bool
    @State private var balloons: [Balloon] = []
    @State private var timeRemaining = 30
    @State private var gameActive = true
    @State private var speedMultiplier = 1.0
    @State private var showAlert = false
    @State private var showPopup = true
    @State private var save = false

    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    private let balloonSpawnInterval = 1.0
    private let maxBalloons = 50
    
    private let goodBalloons = ["imagen1", "imagen2", "imagen3", "imagen4", "imagen5", "imagen6"]
    private let badBalloons = ["animal1", "animal2", "animal3", "animal4"]
    
    var body: some View {
        ZStack {
            // Fondo con imagen
            Image("game1") //
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ForEach(balloons) { balloon in
                BalloonView(balloon: balloon)
                    .onTapGesture {
                        popBalloon(balloon)
                    }
            }
            
            VStack {
                Text("Tiempo: \(timeRemaining)")
                    .font(.custom("Bebas Neue", size: 25))
                    .foregroundColor(.blue)
                    .padding(.top, 50)
                
                Spacer()
            }

            if showPopup {
                PopUpView(popup: $showPopup, save: $save)
            }
            
            ScoreView()
                .offset(x: screenWidth / 2 - 150, y: -screenHeight / 2 + 80)
            
            if !gameActive {
                VStack {
                    Text("¡Juego terminado!")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding()
                    Text("Puntuación final: \(gameData.score)")
                        .font(.title)
                        .foregroundColor(.orange)
                    Button(action: {
                        showAlert = true
                    }) {
                        Text("Continuar")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text("¿Quieres seguir jugando?"),
                            primaryButton: .default(Text("Sí")) {
                                resetGame()
                            },
                            secondaryButton: .destructive(Text("No")) {
                                isPresented = false
                            }
                        )
                    }
                }
                .background(Color.black.opacity(0.8))
                .cornerRadius(20)
            }
        }

        .onChange(of: save) {
            if save {
                startGameTimer()
                startSpawningBalloons()
            }
        }
    }
    
    func popBallon() {
        gameData.score += 10
    }
    
    func startGameTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                gameActive = false
            }
        }
    }
    
    func startSpawningBalloons() {
        var balloonsSpawned = 0
        Timer.scheduledTimer(withTimeInterval: balloonSpawnInterval, repeats: true) { timer in
            if balloonsSpawned < maxBalloons && gameActive {
                spawnBalloon()
                balloonsSpawned += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func spawnBalloon() {
        let randomXPosition = CGFloat.random(in: 50...(screenWidth - 50))
        let isBad = Bool.random()
        let imageName = isBad ? badBalloons.randomElement()! : goodBalloons.randomElement()!
        let randomSpeed = Double.random(in: 3...6) / speedMultiplier
        let randomRotation = Double.random(in: -360...360)
        let randomSize = CGFloat.random(in: 50...100)
        
        let initialPosition = CGPoint(x: randomXPosition, y: screenHeight + 50)
        
        let balloon = Balloon(
            position: initialPosition,
            imageName: imageName,
            speed: randomSpeed,
            isBad: isBad,
            rotation: randomRotation,
            size: randomSize
        )
        
        balloons.append(balloon)
        
        withAnimation(.linear(duration: randomSpeed)) {
            moveBalloonToTop(balloon.id)
        }
    }
    
    private func moveBalloonToTop(_ balloonID: UUID) {
        if let index = balloons.firstIndex(where: { $0.id == balloonID }) {
            balloons[index].position = CGPoint(x: balloons[index].position.x, y: -150)
        }
    }
    
    private func popBalloon(_ balloon: Balloon) {
        if let index = balloons.firstIndex(where: { $0.id == balloon.id }) {
            if !balloons[index].isPopped {
                balloons[index].isPopped = true
                
                if balloons[index].isBad {
                    gameData.score -= 5
                } else {
                    gameData.score += 5
                }
                
                speedMultiplier += 0.1
            }
        }
    }
    
    //Reiniciar el juego correctamente
    private func resetGame() {
        timeRemaining = 30
        gameActive = true
        balloons.removeAll()
        speedMultiplier = 1.0
        
        // Volver a iniciar el temporizador y los globos
        startGameTimer()
        startSpawningBalloons()
    }
}

#Preview {
    @State var isPresented: Bool = true
    GameView(isPresented: $isPresented).environmentObject(GameData())
}
