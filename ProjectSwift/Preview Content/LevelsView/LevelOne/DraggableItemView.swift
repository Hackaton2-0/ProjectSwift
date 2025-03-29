//
//  DraggableItemView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 22/03/25.
//

import SwiftUI

struct DraggableItemView: View {
    var imageName: String
    var start: CGSize
    var targetPosition: CGPoint
    var onDrop: () -> Void
    var size: CGFloat

    @State private var offset: CGSize
    @State private var drag: CGSize = .zero
    @State private var isHidden: Bool = false

    init(imageName: String, start: CGSize, targetPosition: CGPoint, size: CGFloat, onDrop: @escaping () -> Void) {
        self.imageName = imageName
        self.start = start
        self.targetPosition = targetPosition
        self.size = size
        self.onDrop = onDrop
        _offset = State(initialValue: start)
    }

    var body: some View {
        if !isHidden {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: size) // ← tamaño dinámico
                .offset(x: offset.width + drag.width, y: offset.height + drag.height)
                .gesture(
                    DragGesture()
                        .onChanged { value in drag = value.translation }
                        .onEnded { _ in
                            offset.width += drag.width
                            offset.height += drag.height
                            drag = .zero

                            let currentX = UIScreen.main.bounds.width * 0.5 + offset.width
                            let currentY = UIScreen.main.bounds.height * 0.5 + offset.height
                            let distance = sqrt(pow(currentX - targetPosition.x, 2) + pow(currentY - targetPosition.y, 2))

                            if distance < 60 {
                                withAnimation(.easeInOut(duration: 0.4)) {
                                    isHidden = true
                                    onDrop()
                                }
                            }
                        }
                )
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.3), value: isHidden)
        }
    }
}


#Preview {
    ZStack {
        Color.white.ignoresSafeArea()
        
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 70, height: 70)
            .position(x: UIScreen.main.bounds.width * 0.7,
                      y: UIScreen.main.bounds.height * 0.5)

        DraggableItemView(
            imageName: "bottle",
            start: CGSize(width: -150, height: 100),
            targetPosition: CGPoint(x: UIScreen.main.bounds.width * 0.7,
                                    y: UIScreen.main.bounds.height * 0.5),
            size: UIScreen.main.bounds.width * 0.05,
            onDrop: {
                print("¡Elemento soltado correctamente!")
            }
        )
    }
}

