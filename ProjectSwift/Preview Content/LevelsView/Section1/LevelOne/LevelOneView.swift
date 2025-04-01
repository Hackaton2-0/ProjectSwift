//
//  LevelOneView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 22/03/25.
//
import SwiftUI

struct LevelOneView: View {
    @EnvironmentObject var gameData: GameData
    var onFinish: (Int) -> Void
    var UISW: CGFloat { UIScreen.main.bounds.width }
    var UISH: CGFloat { UIScreen.main.bounds.height }

    @State private var timeRemaining = 60
    @State private var showStartPopup = true
    @State private var showEndPopup = false
    @State private var itemsRemaining = 14
    @State private var save = false
    @State private var timer: Timer?
    @State private var itemStates: [Bool] = Array(repeating: true, count: 14)
    @State private var estrellasObtenidas: Int = 0
    @State private var showExitConfirmation = false
    @State private var pauseTime = false
    @State private var showExitPopup = false
    @State private var showConfiguration = false
    @State private var rotateIcon = false
    @Binding var contentReturn: Bool
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Group {
                Image("game1")
                    .resizable()
                    .ignoresSafeArea()
                
                Image("plastic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UISW * 0.25)
                    .position(x: UISW * 0.82, y: UISH * 0.57)
                
                Image("glass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UISW * 0.25)
                    .position(x: UISW * 0.20, y: UISH * 0.60)
                
                Image("organic")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UISW * 0.30)
                    .position(x: UISW * 0.52, y: UISH * 0.90)
                
                Image("paper")
                    .resizable()
                    .scaledToFit()
                    .frame(width: UISW * 0.25)
                    .position(x: UISW * 0.73, y: UISH * 0.75)
                
                //plastic
                DraggableItemView(
                    imageName: "bottle",
                    start: CGSize(width: -UISW * 0.45, height: UISH * 0.35),
                    targetPosition: CGPoint(x: UISW * 0.85, y: UISH * 0.57),
                    size: UISW * 0.10,
                    onDrop: { markItemDropped(at: 0) }
                )
                DraggableItemView(
                    imageName: "bag",
                    start: CGSize(width: UISW * 0.45, height: UISH * 0.35),
                    targetPosition: CGPoint(x: UISW * 0.85, y: UISH * 0.57),
                    size: UISW * 0.10,
                    onDrop: { markItemDropped(at: 1) }
                )
                DraggableItemView(
                    imageName: "glasslid",
                    start: CGSize(width: -UISW * 0.36, height: -UISH * 0.2),
                    targetPosition: CGPoint(x: UISW * 0.85, y: UISH * 0.57),
                    size: UISW * 0.12,
                    onDrop: { markItemDropped(at: 2) }
                )
                DraggableItemView(
                    imageName: "glass1",
                    start: CGSize(width: UISW * 0.44, height: -UISH * 0.23),
                    targetPosition: CGPoint(x: UISW * 0.85, y: UISH * 0.57),
                    size: UISW * 0.15,
                    onDrop: { markItemDropped(at: 3) }
                ) // glass
                DraggableItemView(
                    imageName: "wine",
                    start: CGSize(width: -UISW * 0.30, height: UISH * 0.23),
                    targetPosition: CGPoint(x: UISW * 0.15, y: UISH * 0.60),
                    size: UISW * 0.10,
                    onDrop: { markItemDropped(at: 4) }
                )
                DraggableItemView(
                    imageName: "pitcher", start: CGSize(width: UISW * 0.40, height: UISH * 0.15),
                    targetPosition: CGPoint(x: UISW * 0.15, y: UISH * 0.60),
                    size: UISW * 0.10,
                    onDrop: { markItemDropped(at: 5) }
                )
                DraggableItemView(
                    imageName: "cup",
                    start: CGSize(width: UISW * 0.15, height: UISH * 0.001),
                    targetPosition: CGPoint(x: UISW * 0.15, y: UISH * 0.60),
                    size: UISW * 0.15,
                    onDrop: { markItemDropped(at: 6) }
                ) //organic
                DraggableItemView(
                    imageName: "carrot",
                    start: CGSize(width: -UISW * 0.13, height: UISH * 0.17),
                    targetPosition: CGPoint(x: UISW * 0.52, y: UISH * 0.90),
                    size: UISW * 0.10,
                    onDrop: { markItemDropped(at: 7) }
                )
                DraggableItemView(
                    imageName: "banana",
                    start: CGSize(width: UISW * 0.10, height: UISH * 0.2),
                    targetPosition: CGPoint(x: UISW * 0.52, y: UISH * 0.90),
                    size: UISW * 0.10,
                    onDrop: { markItemDropped(at: 8) }
                )
                DraggableItemView(
                    imageName: "apple",
                    start: CGSize(width: -UISW * 0.36, height: UISH * 0.027),
                    targetPosition: CGPoint(x: UISW * 0.52, y: UISH * 0.90),
                    size: UISW * 0.07,
                    onDrop: { markItemDropped(at: 9) }
                )
                DraggableItemView(
                    imageName: "fish",
                    start: CGSize(width: -UISW * 0.01, height: -UISH * 0.3),
                    targetPosition: CGPoint(x: UISW * 0.52, y: UISH * 0.90),
                    size: UISW * 0.17,
                    onDrop: { markItemDropped(at: 10) }
                ) //paper
                DraggableItemView(
                    imageName: "periodico",
                    start: CGSize(width: -UISW * 0.36, height: -UISH * 0.4),
                    targetPosition: CGPoint(x: UISW * 0.73, y: UISH * 0.75),
                    size: UISW * 0.08,
                    onDrop: { markItemDropped(at: 11) }
                )
                DraggableItemView(
                    imageName: "carton",
                    start: CGSize(width: UISW * 0.42, height: -UISH * 0.4),
                    targetPosition: CGPoint(x: UISW * 0.73, y: UISH * 0.75),
                    size: UISW * 0.18,
                    onDrop: { markItemDropped(at: 12) }
                )
                DraggableItemView(
                    imageName: "rollos",
                    start: CGSize(width: UISW * 0.26, height: UISH * 0.4),
                    targetPosition: CGPoint(x: UISW * 0.73, y: UISH * 0.75),
                    size: UISW * 0.15,
                    onDrop: { markItemDropped(at: 13) }
                )
                
                HStack {
                    Button(action: {
                        pauseTime = true
                        timer?.invalidate()
                        showExitPopup = true
                    }) {
                        Image(systemName: "arrowshape.turn.up.left")
                            .font(.title2.bold())
                            .frame(width: 30, height: 10)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                    }

                    Spacer()

                    Text("Tiempo: \(timeRemaining)")
                        .font(.custom("Bebas Neue", size: 25))
                        .foregroundColor(.blue)

                    Spacer()
                    
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 35))
                        .rotationEffect(.degrees(rotateIcon ? 360 : 0))
                        .onTapGesture {
                            withAnimation {
                                showConfiguration.toggle()
                                rotateIcon.toggle()
                            }
                        }
                    
                }
                .padding()
                .padding(.top, 05)
                .background(Color.gray.opacity(0.4))
                .position(x: UISW * 0.50, y: UISH * 0.02)
                
                if showConfiguration {
                    ConfigurationView(showConfig: $showConfiguration)
                        .environmentObject(gameData)
                        .offset(x: 250, y: -535)
                }
                
                if showEndPopup {
                    endGamePopup()
                }
            }
            .allowsHitTesting(!showStartPopup)
            
            if showStartPopup {
                Color.black
                    .opacity(0.7).ignoresSafeArea()
                PopUpView(
                    popup: $showStartPopup,
                    save: $save,
                    instructions: "Arrastra los objetos a su contenedor correcto antes de que se acabe el tiempo"
                )
                .zIndex(1)
                .allowsHitTesting(true)
            }
            
            if showExitPopup {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    Text("¿Deseas salir del juego?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)

                    Text("Si sales, no se contará ninguna estrella.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)

                    HStack(spacing: 20) {
                        Button("Salir") {
                            isPresented = false
                        }
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("Continuar") {
                            pauseTime = false
                            startTimer()
                            showExitPopup = false
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
                .zIndex(2)
            }
        }
        .onChange(of: save) {
            if save {
                startTimer()
            }
        }
        .alert("¿Deseas salir del juego?", isPresented: $showExitConfirmation) {
            Button("Sí, regresar", role: .destructive) {
                isPresented = false 
            }
            Button("Continuar", role: .cancel) {
                pauseTime = false
                startTimer()
            }
        } message: {
            Text("Si sales, no se contará ninguna estrella.")
        }
    }
        
    private func endGamePopup() -> some View {
           VStack(spacing: 16) {
               Text("¡Nivel completado!")
                   .font(.title)
                   .fontWeight(.bold)

               HStack(spacing: 8) {
                   ForEach(0..<3) { index in
                       Image(systemName: index < estrellasObtenidas ? "star.fill" : "star")
                           .resizable()
                           .frame(width: 40, height: 40)
                           .foregroundColor(.yellow)
                   }
               }

               Text("Tiempo: \(60 - timeRemaining) segundos")
                   .font(.subheadline)

               HStack(spacing: 20) {
                   Button("Reintentar") {
                       resetGame()
                   }
                   .padding()
                   .background(Color.blue)
                   .foregroundColor(.white)
                   .cornerRadius(10)

                   Button("Salir") {
                       onFinish(estrellasObtenidas)
                       isPresented = false
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

    private func resetGame() {
        timeRemaining = 60
        itemStates = Array(repeating: true, count: 14)
        itemsRemaining = 14
        showEndPopup = false
        startTimer()
    }
        
    private func itemDropped() {
        itemsRemaining -= 1
        if itemsRemaining == 0 {
            timer?.invalidate()
            calcularEstrellasYActualizarPuntuacion()
            showEndPopup = true
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if pauseTime {
                return // Pausado, no hace nada
            }

            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                t.invalidate()
                showEndPopup = true
                calcularEstrellasYActualizarPuntuacion()
            }
        }
    }

    private func calcularEstrellasYActualizarPuntuacion() {
        let tiempo = 60 - timeRemaining
        let estrellas: Int

        switch tiempo {
        case 1...20: estrellas = 3
        case 21...40: estrellas = 2
        case 41...60: estrellas = 1
        default: estrellas = 0
        }
        estrellasObtenidas = estrellas

        switch estrellas {
        case 1: gameData.score += 5
        case 2: gameData.score += 10
        case 3: gameData.score += 15
        default: break
        }

        if estrellas == 1 || estrellas == 2 {
            if gameData.lives > 0 {
                gameData.lives -= 1
            }
        }
    }

    
    private func checkIfAllDropped() {
        print("Estados: \(itemStates)")
        if itemStates.allSatisfy({ !$0 }) {
            print("¡Todos colocados!")
            timer?.invalidate()
            calcularEstrellasYActualizarPuntuacion()
            showEndPopup = true
        }
    }
    
    private func markItemDropped(at index: Int) {
        itemStates[index] = false
        playEffectSound(sound: .Basura)
        checkIfAllDropped()
    }

    

}

#Preview {
    LevelOneView(
        onFinish: { estrellas in
            print("Estrellas en preview: \(estrellas)")
        },
        contentReturn: .constant(true), isPresented: .constant(true)
    )
    .environmentObject(GameData())
}

