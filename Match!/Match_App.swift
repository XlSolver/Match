//
//  Match_App.swift
//  Match!
//
//  Created by Salvatore Flauto on 27/11/23.
//

import SwiftUI
//import SwiftData
import MapKit
import Firebase
import FirebaseCore
import FirebaseDatabase


@main
struct Match_App: App {
//    let container: ModelContainer
//    
//    init() {
//        do {
//            let playerDB = ModelConfiguration(for: Player.self)
//            let matchDB = ModelConfiguration(for: Match.self)
//            let database = ModelConfiguration(for: Player.self, Match.self, isStoredInMemoryOnly: true)
//            
//            container = try ModelContainer(for: Player.self, Match.self, configurations: database)
//        } catch {
//            fatalError("Failed to configurate SwiftData container.")
//        }
//    }
    @UIApplicationDelegateAdaptor (AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
//            AllMatchView(player: .constant(Player(name: "", surname: "", age: 0, skillLevel: 0, profilePicture: Data())), match: .constant([Match]()), position: .constant(MapCameraPosition.automatic), markerSelector: .constant(nil), searchLocation: .constant("Vesuvio"), price: .constant(0.0), lookAroundScene: .constant(nil), matchName: .constant(""))
//            PlayerView(player: Player(name: "Ciccio", surname: "Pasticcio", age: 10, skillLevel: 12, profilePicture: Data()))
        }
//        .modelContainer(container)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
