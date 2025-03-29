//
//  PopUpPuzzle.swift
//  ProjectSwift
//
//  Created by Katherine Montes on 27/03/25.
//

import SwiftUI

struct PopUpPuzzle: View {
    var timeElapsed: Int
    var onClose: () -> Void

    private func starCount() -> Int {
        switch timeElapsed {
        case 1...20: return 3
        case 21...40: return 2
        case 41...60: return 1
        default: return 0
        }
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("!Nivel completado!")
                .font(.title)
                .fontWeight(.bold)

            HStack(spacing: 8) {
                ForEach(0..<3) { index in
                    Image(systemName: index < starCount() ? "star.fill" : "star")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.yellow)
                }
            }

            Text("Tiempo: \(timeElapsed) segundos")
                .font(.subheadline)

            Button("Cerrar") {
                onClose()
            }
            .padding(.top, 10)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
        .frame(maxWidth: 300)
    }
}

#Preview("3 estrellas (rápido)") {
    PopUpPuzzle(timeElapsed: 10) { }
}

#Preview("2 estrellas (medio)") {
    PopUpPuzzle(timeElapsed: 35) { }
}

#Preview("1 estrella (tarde)") {
    PopUpPuzzle(timeElapsed: 45) { }
}

#Preview("0 estrellas (fuera de rango)") {
    PopUpPuzzle(timeElapsed: 65) { }
}
