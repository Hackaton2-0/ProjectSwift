//
//  LevelOneThree.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 02/04/25.
//

import SwiftUI

struct LevelOneThreeView: View {
    var onFinish: (Int) -> Void
    @Binding var contentReturn: Bool
    @Binding var isPresented: Bool
    @EnvironmentObject var gameData: GameData
    
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    @State private var characterPosition = CGSize(width: 0, height: 0)
    @State private var backgroundOffset: CGFloat = 0
    @State private var collected = Set<Int>()
    @State private var currentCharacterImage = "derecha"
    @State private var moveTimer: Timer? = nil
    
    @State private var timeCounter = 0
    @State private var showStartPopup = true
    @State private var showEndPopup = false
    @State private var showFactPopup = false
    @State private var currentFact: String = ""
    @State private var save = false
    @State private var timer: Timer?
    @State private var estrellasObtenidas: Int = 0
    @State private var showExitConfirmation = false
    @State private var pauseTime = false
    @State private var showExitPopup = false
    @State private var showConfiguration = false
    @State private var rotateIcon = false

    let itemImages = ["imagen1", "imagen2", "imagen3", "imagen4", "imagen5", "imagen6"]
    
    private func generateRandomPositions() -> [CGPoint] {
        var positions: [CGPoint] = []
        let screenWidth: CGFloat = 2000
        let screenHeight: CGFloat = 1000
        let padding: CGFloat = 100

        for _ in 0..<itemImages.count {
            let x = CGFloat.random(in: padding...(screenWidth - padding))
            let y = CGFloat.random(in: padding...(screenHeight - padding))
            positions.append(CGPoint(x: x, y: y))
        }
        return positions
    }
    
    @State private var itemPositions: [CGPoint] = []

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("fondoreal")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width * 3, height: geometry.size.height * 1.00  )
                    .offset(x: -backgroundOffset)
                    .animation(.easeInOut(duration: 0.3), value: backgroundOffset)
            }
            
            VStack(alignment: .center) {
                HStack(alignment: .center) {
                    Text("Has recogido: \(collected.count)/\(itemImages.count)")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(8)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                }
            }
            .offset(y: 550)
            
            ForEach(0..<itemPositions.count, id: \.self) { index in
                if !collected.contains(index) {
                    Image(itemImages[index])
                        .resizable()
                        .frame(width: 80, height: 80)
                        .position(x: itemPositions[index].x - backgroundOffset,
                                  y: itemPositions[index].y)
                        .animation(.easeInOut(duration: 0.3), value: backgroundOffset)
                }
            }
            
            Image(currentCharacterImage)
                .resizable()
                .frame(width: 100, height: 100)
                .position(x: characterPosition.width + 55, y: characterPosition.height + 150)
                .animation(.easeInOut(duration: 0.3), value: characterPosition)
            
            HStack(alignment: .center, spacing : 200) {
                HStack(spacing: 20) {
                    Image(systemName: "arrow.left.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    if moveTimer == nil {
                                        currentCharacterImage = "izquierda"
                                        moveTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                                            moveCharacter(x: -5, y: 0)
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    moveTimer?.invalidate()
                                    moveTimer = nil
                                }
                        )
                    
                    VStack {
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        if moveTimer == nil {
                                            currentCharacterImage = "animal1"
                                            moveTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                                                moveCharacter(x: 0, y: -5)
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        moveTimer?.invalidate()
                                        moveTimer = nil
                                    }
                            )
                        
                        Image(systemName: "arrow.down.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { _ in
                                        if moveTimer == nil {
                                            currentCharacterImage = "animal2"
                                            moveTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                                                moveCharacter(x: 0, y: 5)
                                            }
                                        }
                                    }
                                    .onEnded { _ in
                                        moveTimer?.invalidate()
                                        moveTimer = nil
                                    }
                            )
                    }
                    Image(systemName: "arrow.right.circle.fill")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { _ in
                                    if moveTimer == nil {
                                        currentCharacterImage = "derecha"
                                        moveTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
                                            moveCharacter(x: 5, y: 0)
                                        }
                                    }
                                }
                                .onEnded { _ in
                                    moveTimer?.invalidate()
                                    moveTimer = nil
                                }
                        )
                }
                Button(action: {
                    checkForPickup()
                }) {
                    Text("Recoger")
                        .font(.caption)
                        .fontWeight(.bold)
                        .frame(width: 80, height: 80)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
            }
            .offset(y: 450)
            
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

                Text("Tiempo: \(timeCounter)")
                    .font(.custom("Bebas Neue", size: 25))
                    .foregroundColor(.black).opacity(0.5)

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
            if showFactPopup {
                Color.black.opacity(0.6).ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("Dato curioso")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                    Text(currentFact)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding()
                        .foregroundColor(.black)
                    Button("OK") {
                        showFactPopup = false
                        showEndPopup = true
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .shadow(radius: 10)
                .frame(maxWidth: 300)
                .zIndex(3)
            }

            if showEndPopup {
                endGamePopup()
            }

            if showStartPopup {
                Color.black.opacity(0.7).ignoresSafeArea()
                PopUpView(
                    popup: $showStartPopup,
                    save: $save,
                    instructions: "¡Ayuda a Balam a buscar las parejas de cada carta!"
                )
                .zIndex(1)
                .allowsHitTesting(true)
            }

            if showExitPopup {
                Color.black.opacity(0.6).ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("¿Deseas salir del juego?")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)

                    Text("Si sales, no se contará ninguna estrella.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)

                    HStack(spacing: 20) {
                        Button("Salir") {
                            isPresented = false
                        }
                        .padding().background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)

                        Button("Continuar") {
                            pauseTime = false
                            startTimer()
                            showExitPopup = false
                        }
                        .padding().background(Color.green)
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
                itemPositions = generateRandomPositions()
                startTimer()
            }
        }
    }


    func moveCharacter(x: CGFloat, y: CGFloat) {
        let screenWidth = UIScreen.main.bounds.width
        let characterWidth: CGFloat = 100
        let newX = characterPosition.width + x
        let newY = characterPosition.height + y

        if x > 0 {
            if characterPosition.width > 150 && backgroundOffset < 2000 - screenWidth {
                backgroundOffset = min(backgroundOffset + x, 2000 - screenWidth)
            } else {
                characterPosition.width = min(characterPosition.width + x, screenWidth - characterWidth)
            }
        }

        else if x < 0 {
            if backgroundOffset > 0 && characterPosition.width < 150 {
                backgroundOffset = max(backgroundOffset + x, 0)
            } else {
                characterPosition.width = max(characterPosition.width + x, 0)
            }
        }

        let screenHeight = UIScreen.main.bounds.height
        characterPosition.height = min(max(-150, newY), screenHeight - 150)
    }



    func checkForPickup() {
        for (index, pos) in itemPositions.enumerated() {
            let personajeX = characterPosition.width + 55
            let personajeY = characterPosition.height + 150

            let dx = pos.x - backgroundOffset - personajeX
            let dy = pos.y - personajeY

            if abs(dx) < 30 && abs(dy) < 30 {
                collected.insert(index)
            }
        }
        if collected.count == itemImages.count {
            timer?.invalidate()
            calcularEstrellasYActualizarPuntuacion()
            showEndPopup = true
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if pauseTime || showStartPopup || showEndPopup || showExitPopup {
                return
            }
            timeCounter += 1
        }
    }

    private func calcularEstrellasYActualizarPuntuacion() {
        let estrellas: Int
        switch timeCounter {
        case 1...40: estrellas = 3
        case 41...80: estrellas = 2
        default: estrellas = 1
        }
        estrellasObtenidas = estrellas

        switch estrellas {
        case 1: gameData.score += 5
        case 2: gameData.score += 10
        case 3: gameData.score += 20
        default: break
        }

        if estrellas < 3, gameData.lives > 0 {
            gameData.lives -= 1
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

            Text("Tiempo: \(timeCounter) segundos")
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
        timeCounter = 0
        estrellasObtenidas = 0
        collected.removeAll()
        currentCharacterImage = "derecha"
        characterPosition = CGSize(width: 0, height: 0)
        backgroundOffset = 0
        showEndPopup = false
        showFactPopup = false
        startTimer()
        itemPositions = generateRandomPositions()
        }

}

#Preview {
    LevelOneThreeView(
        onFinish: { estrellas in
            print("Estrellas en preview \(estrellas)")
        },
        contentReturn: .constant(true),
        isPresented: .constant(true)
    )
        .environmentObject(GameData())
}
