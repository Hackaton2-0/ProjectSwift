//
//  SplashScreen.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 01/04/25.
//
import SwiftUI

struct SplashScreen: View {
    @State var isActive : Bool = false
    @State private var size = 0.4
    @State private var opacity = 0.5
    
    // Customise your SplashScreen here
    var body: some View {
        if isActive {
            PrincipalView()
        } else {
            ZStack {
                Color(.gray).ignoresSafeArea().opacity(0.8)
                VStack (spacing: 50) {
                    ZStack{
                        Circle()
                            .foregroundColor(.green).opacity(0.4)
                            .frame(width: 550, height: 550)
                        Image("jaguarfrente")
                            .resizable()
                            .frame(width: 400, height: 400)
                            .font(.system(size: 80))
                    }
                    Text("NovaCode")
                        .font(Font.custom("Baskerville-Bold", size: 36))
                        .foregroundColor(.black.opacity(0.80))
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 0.9
                        self.opacity = 1.00
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreen()
}
