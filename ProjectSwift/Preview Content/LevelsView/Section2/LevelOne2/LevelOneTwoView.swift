//
//  LevelOne2.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 31/03/25.
//

import SwiftUI

struct LevelOneTwoView: View {
    var onFinish: (Int) -> Void
    @Binding var contentReturn: Bool
    @Binding var isPresented: Bool
    @EnvironmentObject var gameData: GameData

    private var threeColumnGrid = Array(repeating: GridItem(.flexible(), spacing: 05), count: 3)
    var UISW: CGFloat { UIScreen.main.bounds.width }
    var UISH: CGFloat { UIScreen.main.bounds.height }

    @State var cards = createCardList().shuffled()
    @State var MatchedCards: [Card] = []
    @State var userChoices: [Card] = []
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

    let funFacts = [
        "¡Sabías que los pulpos tienen tres corazones!",
        "Los caballitos de mar macho son los que quedan embarazados.",
        "Una medusa puede ser inmortal biológicamente.",
        "El pez payaso puede cambiar de sexo.",
        "Las estrellas de mar no tienen cerebro.",
        "El océano produce más del 50% del oxígeno que respiramos."
    ]

    init(
        onFinish: @escaping (Int) -> Void,
        contentReturn: Binding<Bool>,
        isPresented: Binding<Bool>
    ) {
        self.onFinish = onFinish
        self._contentReturn = contentReturn
        self._isPresented = isPresented
    }

    var body: some View {
        ZStack {
            Color.green.ignoresSafeArea().opacity(0.7)

            GeometryReader { geo in
                VStack(spacing: 30) {
                    Text("Memorama")
                        .font(.custom("Bebas Neue", size: 25))

                    LazyVGrid(columns: threeColumnGrid, spacing: 20) {
                        ForEach(cards) { card in
                            CardView(
                                card: card,
                                width: Int(geo.size.width / 6),
                                MatchedCards: $MatchedCards,
                                userChoices: $userChoices
                            )
                        }
                    }

                    VStack(spacing: 30) {
                        Text("Cartas que faltan")
                            .font(.custom("Bebas Neue", size: 25))

                        LazyVGrid(columns: threeColumnGrid, spacing: 10) {
                            ForEach(cardValues, id: \.self) { cardValue in
                                if !MatchedCards.contains(where: { $0.imageName == cardValue }) {
                                    Image(cardValue)
                                        .resizable()
                                        .scaledToFit()
                                        .padding()
                                        .frame(width: 90, height: 90)
                                }
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .offset(y: 170)
            }

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

                    Text("Si sales, no se contará ninguna estrella.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)

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
                startTimer()
            }
        }
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            if pauseTime { return }
            timeCounter += 1

            if MatchedCards.count == cards.count {
                t.invalidate()
                calcularEstrellasYActualizarPuntuacion()
                currentFact = funFacts.randomElement() ?? ""
                showFactPopup = true
            }
        }
    }

    private func calcularEstrellasYActualizarPuntuacion() {
        let estrellas: Int
        switch timeCounter {
        case 1...20: estrellas = 3
        case 21...40: estrellas = 2
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
        MatchedCards.removeAll()
        userChoices.removeAll()
        cards = createCardList().shuffled()
        showEndPopup = false
        showFactPopup = false
        startTimer()
    }
}


#Preview {
    LevelOneTwoView(
        onFinish: { estrellas in
            print("Estrellas en preview: \(estrellas)")
        },
        contentReturn: .constant(true),
        isPresented: .constant(true)
    )
    .environmentObject(GameData())
}
