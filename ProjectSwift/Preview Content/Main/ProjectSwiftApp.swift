//
//  ProjectSwiftApp.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 08/03/25.
//

import SwiftUI

@main
struct ProjectSwiftApp: App {
    //let persistenceController = PersistenceController.shared
    //@StateObject private var gameData = GameData()

    var body: some Scene {
        WindowGroup {
            SplashScreen()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
                //.environmentObject(gameData)
        }
    }
}
