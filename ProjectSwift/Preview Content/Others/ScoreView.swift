//
//  ScoreView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 12/03/25.
//

import SwiftUI

var areEffectsEnabled: Bool = true

struct ScoreView: View {
    @EnvironmentObject var gameData: GameData
    @State private var showConfiguration = false
    @State private var showHeartShop = false
    @State private var isPulsingC = false
    @State private var isPulsingH = false
    @State private var rotateIcon = false
    @State private var pulseHeart = false
    @State private var pulseGear = false

    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cyan.opacity(0.4))
                .frame(width: 280, height: 50)
            
            HStack(spacing: 20) {
                Text("Puntuación:  \(Text("\(gameData.score)").foregroundColor(.orange))")
                    .font(.custom("Bebas Neue", size: 25))
                    .foregroundColor(.red)
                
                HStack(spacing: 10) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(gameData.lives > 0 ? .red : .gray)
                        .font(.system(size: 30))
                        .scaleEffect(isPulsingH ? 1.2 : 1.0)
                        .scaleEffect(pulseHeart ? 1.2 : 1.0)
                        .onTapGesture {
                            withAnimation {
                                showConfiguration = false
                                showHeartShop.toggle()
                                isPulsingH = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                    isPulsingH = false
                                }
                            }
                        }
                    
                    Text("\(gameData.lives)")
                        .font(.custom("Bebas Neue", size: 25))
                }
                
                Image(systemName: "gearshape.fill")
                    .foregroundColor(.black)
                    .font(.system(size: 30))
                    .scaleEffect(isPulsingC ? 1.2 : 1.0)
                    .scaleEffect(pulseGear ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isPulsingC)
                    .rotationEffect(.degrees(rotateIcon ? 360 : 0))
                    .onTapGesture {
                        withAnimation {
                            showHeartShop = false
                            showConfiguration.toggle()
                            isPulsingC = true
                            rotateIcon.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                isPulsingC = false
                            }
                        }
                    }
            }
            .padding()
            
            if showConfiguration {
                ConfigurationView(showConfig: $showConfiguration)
                    .environmentObject(gameData)
                    .offset(y: 70)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: showConfiguration)
            }
            
            if showHeartShop {
                HeartShopView(isPresented: $showHeartShop)
                    .environmentObject(gameData)
                    .offset(y: 160)
                    .transition(.scale.combined(with: .opacity))
                    .animation(.easeInOut(duration: 0.3), value: showHeartShop)
            }
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                withAnimation(.easeInOut(duration: 0.8)) {
                    pulseHeart.toggle()
                    pulseGear.toggle()
                }
            }
        }
    }

    private func heartOption(amount: Int, cost: Int) -> some View {
        VStack {
            ZStack {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .font(.system(size: 45))

                Text("\(amount)")
                    .font(.custom("Bebas Neue", size: 25))
                    .foregroundColor(.white)
            }
            Text("\(cost) pts")
                .font(.custom("Bebas Neue", size: 25))
                .foregroundColor(.black)
        }
        .frame(width: 70)
    }
}

#Preview {
    ScoreView().environmentObject(GameData())
}


struct ConfigurationView: View {
    @EnvironmentObject var gameData: GameData
    @Binding var showConfig: Bool
    
    @State private var isPulsing1 = false
    @State private var isPulsing2 = false
    @State private var isPressedVoice: Bool = false
    @State private var isPressedSound: Bool = false
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.cyan.opacity(0.4))
                .frame(width: 150, height: 50)
            
            HStack(spacing: 25) {
                Image(systemName: isPressedVoice ? "speaker.slash.fill" : "speaker.wave.2.fill")
                    .foregroundColor(.black)
                    .font(.title)
                    .frame(width: 30, height: 30)
                    .scaleEffect(isPulsing1 ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isPulsing1)
                    .onTapGesture {
                        isPressedVoice.toggle()
                        if isPressedVoice {
                            stopBackgroundSound()
                        } else {
                            playBackgroundSound(sound: .IntroCumbia)
                        }
                        isPulsing1 = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isPulsing1 = false
                        }
                    }
                
                Image(systemName: isPressedSound ? "waveform.slash" : "waveform")
                    .foregroundColor(.black)
                    .font(.title)
                    .frame(width: 30, height: 30)
                    .scaleEffect(isPulsing2 ? 1.2 : 1.0)
                    .animation(.easeInOut(duration: 0.2), value: isPulsing2)
                    .onTapGesture {
                        isPressedSound.toggle()
                        areEffectsEnabled = !isPressedSound // ← desactiva efectos si está presionado
                        isPulsing2 = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isPulsing2 = false
                        }
                    }
            }
        }
    }
}
