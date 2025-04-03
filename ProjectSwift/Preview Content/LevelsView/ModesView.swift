//
//  ModesView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 26/03/25.
//

import SwiftUI

struct ModesView: View {
    var UISW: CGFloat = UIScreen.main.bounds.width
    var UISH: CGFloat = UIScreen.main.bounds.height
    @Binding var showPrincipal: Bool
    //@EnvironmentObject var gameData: GameData

    enum SelectedView {
        case main
        case levelP
        case levelG
        case levelA
    }

    @State private var selectedView: SelectedView = .main
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                switch selectedView {
                case .main:
                    BounceDisabledScrollView(.horizontal) {
                        ZStack {
                            Image("fondoreal")
                                .resizable()
                                .scaledToFill()
                                .frame(width: geometry.size.width * 3, height: geometry.size.height * 1.00)

                            HStack(spacing: 440) {
                                ForEach(cards) { card in
                                    VStack {
                                        Button(action: {
                                            selectedView = card.destination
                                        }) {
                                            ZStack {
                                                Circle()
                                                    .fill(.ultraThinMaterial)
                                                    .frame(width: 400, height: 300)
                                                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                                                    .overlay(
                                                        Circle()
                                                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                                                    )

                                                Image(card.imageName)
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: 300, height: 300) 
                                            }
                                        }

                                        Text(card.title)
                                            .font(.largeTitle.bold())
                                            .foregroundStyle(.white)
                                            .shadow(color:
                                                .black.opacity(0.7), radius: 4, x: 2, y: 2)
                                            .padding(.top, 10)

                                    }
                                }
                            }
                            .padding()
                        }
                    }


                default:
                    EmptyView()
                }
            }
            .fullScreenCover(isPresented: Binding<Bool>(
                get: { selectedView != .main },
                set: { if !$0 { selectedView = .main } }
            )) {
                switch selectedView {
                case .levelP:
                    ContentView(
                        score: 0,
                        isPressented: Binding(
                            get: { selectedView != .main },
                            set: { if !$0 { selectedView = .main } }
                        )
                    )

                case .levelG:
                    ContentView2(
                        score: 0,
                        isPressented: Binding(
                            get: { selectedView != .main },
                            set: { if !$0 { selectedView = .main } }
                        )
                    )

                case .levelA:
                    ContentView3(
                        score: 0,
                        isPressented: Binding(
                            get: { selectedView != .main },
                            set: { if !$0 { selectedView = .main } }
                        )
                    )

                default:
                    EmptyView()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    var cards: [Card] {
        [
            Card(title: "El bosque de Pachito", imageName: "tlacua", colors: [.colorOne, .colorTwo], destination: .levelP),
            Card(title: "La selva de Balam", imageName: "jaguarsentao", colors: [.colorOne, .colorFive], destination: .levelG),
            Card(title: "El mar de Chelonio", imageName: "tortugagolfina", colors: [.colorTree, .colorTwo], destination: .levelA)
        ]
    }

    struct Card: Identifiable {
        let id = UUID()
        let title: String
        let imageName: String
        let colors: [Color]
        let destination: SelectedView
    }
}

#Preview {
    StatefulPreviewWrapper(false) { show in
        ModesView(showPrincipal: show)
    }
}

