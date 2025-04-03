//
//  StarsView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 22/03/25.
//

import SwiftUI

struct StarRatingPopup: View {
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
            Text("¡Nivel completado!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)

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
                .foregroundColor(.black)

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
    StarRatingPopup(timeElapsed: 10) { }
}

#Preview("2 estrellas (medio)") {
    StarRatingPopup(timeElapsed: 35) { }
}

#Preview("1 estrella (tarde)") {
    StarRatingPopup(timeElapsed: 45) { }
}

#Preview("0 estrellas (fuera de rango)") {
    StarRatingPopup(timeElapsed: 65) { }
}



