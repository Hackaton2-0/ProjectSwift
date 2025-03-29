//
//  DraggablePuzzleView.swift
//  ProjectSwift
//
//  Created by Katherine Montes on 23/03/25.
//

import SwiftUI
import ConfettiSwiftUI

struct DraggablePuzzleView: View {
    @State private var piezasColocadas: Int = 0
    @State private var piezasMezcladas: [String] = (1...9).map { "ab\($0)" }.shuffled()

    var body: some View {
        ZStack {
            // Fondo degradado tipo cielo
            
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.85, green: 0.99, blue: 1.0), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            // Imagen decorativa sobre el degradado
                Image("fondovacio")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            // Imagen de fondo
            Image("abgenbasura")
                .resizable()
                .frame(width: 500, height: 500)
                .position(x: UIScreen.main.bounds.width * 0.5, y: 300)

            // Mostrar piezas revueltas con posiciones iniciales
            ForEach(piezasMezcladas.indices, id: \.self) { index in
                let imageName = piezasMezcladas[index]
                let piezaNum = Int(imageName.dropFirst(2))!
                let col = (piezaNum - 1) % 3
                let row = (piezaNum - 1) / 3

                LocalPuzzlePiece(imageName: imageName,
                                 start: initialStart(for: index + 1),
                                 targetPosition: targetPosition(row: row, col: col),
                                 size: 320,
                                 onDrop: {
                                     piezasColocadas += 1
                                 })
            }

            VStack {
                Spacer()
                Text("Piezas colocadas: \(piezasColocadas)/9")
                    .font(.headline)
                    .padding(.bottom, 40)
            }
        }
    }

    func targetPosition(row: Int, col: Int) -> CGPoint {
        let gridSize: CGFloat = 270
        let cellSize: CGFloat = 90
        let x = UIScreen.main.bounds.width * 0.5 - gridSize / 2 + CGFloat(col) * cellSize + cellSize / 2
        let y = 300 + CGFloat(row) * cellSize + cellSize / 2
        return CGPoint(x: x, y: y)
    }

    func initialStart(for index: Int) -> CGSize {
        let starts = [
            CGSize(width: -150, height: 20),
            CGSize(width: 0, height: 20),
            CGSize(width: 150, height: 20),
            CGSize(width: -150, height: 170),
            CGSize(width: 0, height: 170),
            CGSize(width: 150, height: 170),
            CGSize(width: -150, height: 310),
            CGSize(width: 0, height: 310),
            CGSize(width: 150, height: 310)
        ]
        return starts[index - 1]
    }
}


// Pieza arrastrable interna (sin desaparecer)
struct LocalPuzzlePiece: View {
    var imageName: String
    var start: CGSize
    var targetPosition: CGPoint
    var onDrop: () -> Void
    var size: CGFloat

    @State private var offset: CGSize
    @State private var drag: CGSize = .zero
    @State private var isPlacedCorrectly: Bool = false

    init(imageName: String, start: CGSize, targetPosition: CGPoint, size: CGFloat, onDrop: @escaping () -> Void) {
        self.imageName = imageName
        self.start = start
        self.targetPosition = targetPosition
        self.size = size
        self.onDrop = onDrop
        _offset = State(initialValue: start)
    }

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFit()
            .frame(width: size)
            .offset(x: offset.width + drag.width, y: offset.height + drag.height)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isPlacedCorrectly {
                            drag = value.translation
                        }
                    }
                    .onEnded { _ in
                        if isPlacedCorrectly {
                            drag = .zero
                            return
                        }

                        offset.width += drag.width
                        offset.height += drag.height
                        drag = .zero

                        let currentX = UIScreen.main.bounds.width * 0.5 + offset.width
                        let currentY = UIScreen.main.bounds.height * 0.5 + offset.height
                        let distance = sqrt(pow(currentX - targetPosition.x, 2) + pow(currentY - targetPosition.y, 2))

                        if distance < 60 {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                offset = CGSize(
                                    width: targetPosition.x - UIScreen.main.bounds.width * 0.5,
                                    height: targetPosition.y - UIScreen.main.bounds.height * 0.5
                                )
                                isPlacedCorrectly = true
                                onDrop()
                            }
                        }
                    }
            )
    }
}

#Preview {
    DraggablePuzzleView()
}
