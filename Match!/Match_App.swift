//
//  Match_App.swift
//  Match!
//
//  Created by Salvatore Flauto on 27/11/23.
//

import SwiftUI
import SwiftData


@main
struct Match_App: App {
    let container: ModelContainer
    
    init() {
        do {
            let playerDB = ModelConfiguration(for: Player.self)
            let matchDB = ModelConfiguration(for: Match.self)
            
            container = try ModelContainer(for: Player.self, Match.self, configurations: playerDB, matchDB)
        } catch {
            fatalError("Failed to configurate SwiftData container.")
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
//            AllMatchView(player: .constant(Player(name: "", surname: "", age: 0, skillLevel: 0, profilePicture: Data())))
            PlayerView(player: Player(name: "Ciccio", surname: "Pasticcio", age: 10, skillLevel: 12, profilePicture: Data()))
        }
        .modelContainer(container)
    }
}
