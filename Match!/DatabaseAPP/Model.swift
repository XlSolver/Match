////
////  Model.swift
////  Match!
////
////  Created by Salvatore Flauto on 27/11/23.
////
//
//import Foundation
//import SwiftUI
//import MapKit
//
///////Class that identify the entity player (Persistent data)
//@Model
//final class Player {
//    var name: String = ""
//    var surname: String = ""
//    var age: Int = 0
//    var skillLevel: Int = 0
//    @Attribute(.externalStorage) var profilePicture: Data? //why: Swiftdata stores files up to 128kb N.B. Can't use predicate on this
////    var playerStats: statistic
//    init(name: String, surname: String, age: Int, skillLevel: Int, profilePicture: Data) {
//        self.name = name
//        self.surname = surname
//        self.age = age
//        self.skillLevel = skillLevel
//        self.profilePicture = profilePicture
//    }
//}
//
///////Class that create an object for a match (Persistent data)
//@Model
//final class Match: Identifiable {
//    var id = UUID()
//    var fieldLatitude: Double = 0.0
//    var fieldLongitude: Double = 0.0
//    var time: Date = Date.now
//    var price: Double = 0.0
//    var matchName: String = "No name"
//    
//    init(fieldLatitude: Double, fieldLongitude: Double, time: Date, price: Double, matchName: String) {
//        self.fieldLatitude = fieldLatitude
//        self.fieldLongitude = fieldLongitude
//        self.time = time
//        self.price = price
//        self.matchName = matchName
//    }
//}
//
///////Stats for every player
//struct statistic {
//    var goal: Int = 0
//    var assist: Int = 0
//    var gamePlayed: Int = 0
//    
//}

import Firebase
import FirebaseDatabaseInternal

//class connectionToTheRealtimeDatabase: JSONSerialization {
//    var matchREF: DatabaseReference! = Database.database().reference(fromURL: "https://match-eff74-default-rtdb.europe-west1.firebasedatabase.app/")
//
//    
//}

//RealTimeDatabase
@Observable
class RTDB {
    //reference set in google.plist
    let matchREF: DatabaseReference = Database.database().reference()
    
    var matchObject: Match? = nil
    
    static var listMatchObject: [Match] = []
}

struct Player: Codable {
    var id = Auth.auth().currentUser?.uid
    var fullName = ""
    var skillLevel: Int = 0
    var matchCreated: [Match]
    var numberMatchCreated: Int = 0
    var matchPlayed: [Match]
    var numberMatchPlayed: Int = 0
//    @Attribute(.externalStorage) var profilePicture: Data? //why: Swiftdata stores files up to 128kb N.B. Can't use predicate on this
//    var playerStats: statistic

}

struct Match: Codable, Hashable {
    var idCreatorOfMatch: String?
    var fieldLatitude: Double = 0.0
    var fieldLongitude: Double = 0.0
    var time: TimeInterval = 0.0
    var price: Double = 0.0
    var matchName: String = "No name"
    var subscribers: Int = 0
    var idPlayerThatWantsToPlay: String?
}
