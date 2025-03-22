//
//  PopUp.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 15/03/25.
//

import SwiftUI

struct PopUpView: View {
    @Binding var popup: Bool
    @Binding var save: Bool
    
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 35)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 20, x: 0, y: 10)
                
                VStack(spacing: 25) {
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 100, height: 100)
                        Image(systemName: "checkmark.seal.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50)
                            .foregroundColor(.blue)
                            .shadow(radius: 5)
                    }
                    
                    Text("¡Todo listo!")
                        .font(.title2.bold())
                        .foregroundColor(.black)
                    
                    Text("¿Listo para comenzar?")
                        .font(.body)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            popup = false
                            save = true
                        }
                    }) {
                        Text("Empezar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 35)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(colors: [.blue, .blue.opacity(0.8)],
                                               startPoint: .leading,
                                               endPoint: .trailing)
                            )
                            .clipShape(Capsule())
                            .shadow(color: .blue.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .frame(width: UISW * 0.8, height: UISH * 0.42)
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    scale = 1.0
                    opacity = 1.0
                }
            }
        }
        .ignoresSafeArea()
    }
}


struct PopUpView_Previews: PreviewProvider {
    @State static var popup = true
    @State static var save = true
    
    static var previews: some View {
        PopUpView(popup: $popup, save: $save)
    }
}
