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
    var instructions: String
    
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    
    var body: some View {
        ZStack{
            ZStack {
                RoundedRectangle(cornerRadius: 30)
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .frame(width: 700, height: 500)
                VStack{
                    Image(systemName: "flag.checkered.2.crossed")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 240)
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                    
                    Text("¿Listo para comenzar?")
                        .font(.custom("Bebas Neue", size: 45))
                        .padding(.top, 50)
                        .foregroundColor(Color.black)
                    
                    Text(instructions)
                        .multilineTextAlignment(.center)
                        .font(.custom("Futura-Medium", size: 30))
                        .padding(.horizontal)
                        .foregroundColor(.red)
                    
                    Button{
                        withAnimation(.easeInOut(duration: 0.3)) {
                            popup = false
                            save = true
                        }
                    }label: {
                        Text("Empezar")
                            .font(.title.bold())
                            .foregroundStyle(.white)
                            .padding()
                    }
                    .background(.blue)
                    .cornerRadius(25)
                    .padding(.top, 30)
                }
            }
            .frame(width: UISW * 0.8, height: UISH * 0.4)
        }.ignoresSafeArea()
    }
}
struct PopUpView_Previews: PreviewProvider {
    @State static var popup = true
    @State static var save = true

    static var previews: some View {
        PopUpView(
            popup: $popup,
            save: $save,
            instructions: "Arrastra los objetos reciclables a su contenedor correcto en menos de 30 segundos"
        )
    }
}


