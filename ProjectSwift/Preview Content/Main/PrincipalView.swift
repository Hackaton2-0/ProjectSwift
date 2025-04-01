//
//  PrincipalView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 27/03/25.
//

import SwiftUI
import AVKit

struct PrincipalView: View {
    @State private var isPressedVoice: Bool = false
    @State private var showModesView = false
    @State private var showLoadingBar = false
    @State private var loadingProgress: CGFloat = 0.0
    
    @State private var floatCharacters = false
    @State private var appearLetters = false
    
    @Environment(\.managedObjectContext) private var context
    //@EnvironmentObject var gameData: GameData

    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height

    var body: some View {
        ZStack {
            Image("introvacio")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                HStack(spacing: -80) {
                    floatingLetter("b")
                    floatingLetter("o")
                    floatingLetter("s")
                    floatingLetter("k")
                    floatingLetter("o2")
                }
                //.padding(.top, 40)
                //.padding(.bottom, 20)
                ZStack {
                    Image("armadillo")
                        .resizable()
                        .frame(width: 600, height: 600)
                        .position(x: UISW * 0.79, y: UISH * 0.38)
                        .offset(y: floatCharacters ? -10 : 10)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: floatCharacters)

                    Image("jaguar")
                        .resizable()
                        .frame(width: 600, height: 600)
                        .position(x: UISW * 0.72, y: UISH * 0.63)
                        .offset(y: floatCharacters ? -10 : 10)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: floatCharacters)

                    Image("monotla")
                        .resizable()
                        .frame(width: 600, height: 600)
                        .position(x: UISW * 0.4, y: UISH * 0.37)
                        .offset(y: floatCharacters ? -10 : 10)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: floatCharacters)

                    Image("ocelote")
                        .resizable()
                        .frame(width: 600, height: 600)
                        .position(x: UISW * 0.33, y: UISH * 0.63)
                        .offset(y: floatCharacters ? -10 : 10)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: floatCharacters)

                }
                .offset(y: -300)
                
                VStack(spacing: 20) {
                    Button {
                        showLoadingBar = true
                        startLoading()
                    } label: {
                        Text("Iniciar")
                            .font(.title2.bold())
                            .frame(width: 150, height: 30)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(15)
                    }

                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: 200, height: 15)
                            .foregroundColor(.white.opacity(0.3))

                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: loadingProgress * 200, height: 15)
                            .foregroundColor(.green)
                            .animation(.linear(duration: 0.05), value: loadingProgress)
                    }
                    .opacity(showLoadingBar ? 1 : 0)
                }
                .offset(y: -180)
            }
        }
        .onAppear {
             playBackgroundSound(sound: .Introduc, fadeOutPrevious: false)
            floatCharacters = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                appearLetters = true
            }
        }
        
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showModesView) {
            ModesView(showPrincipal: $showModesView)
                //.environmentObject(gameData)
        }
        
    }

    private func startLoading() {
        loadingProgress = 0
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            if loadingProgress < 1.0 {
                loadingProgress += 0.02
            } else {
                timer.invalidate()
                showModesView = true
            }
        }
    }
        private func floatingLetter(_ imageName: String) -> some View {
            Image(imageName)
                .resizable()
                .frame(width: 250, height: 250)
                .scaleEffect(appearLetters ? 1.0 : 0.5)
                .opacity(appearLetters ? 1.0 : 0.0)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.5)
                        .delay(Double(imageName.hash % 5) * 0.1),
                    value: appearLetters
                )
        }
}

#Preview {
    PrincipalView()
}
