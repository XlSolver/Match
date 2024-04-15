//
//  Model.swift
//  Match!
//
//  Created by Salvatore Flauto on 27/11/23.
//

import Foundation
import SwiftData
import SwiftUI
import MapKit

/////Class that identify the entity player (Persistent data)
@Model
final class Player {
    var name: String = ""
    var surname: String = ""
    var age: Int = 0
    var skillLevel: Int = 0
    @Attribute(.externalStorage) var profilePicture: Data? //why: Swiftdata stores files up to 128kb N.B. Can't use predicate on this
//    var playerStats: statistic
    init(name: String, surname: String, age: Int, skillLevel: Int, profilePicture: Data) {
        self.name = name
        self.surname = surname
        self.age = age
        self.skillLevel = skillLevel
        self.profilePicture = profilePicture
    }
}

/////Class that create an object for a match (Persistent data)
@Model
final class Match: Identifiable {
    var id = UUID()
    var fieldLatitude: CLLocation?
    var fieldLongitude: CLLocation?
    var time: Date = Date.now
    var price: Double = 0.0
    var matchName: String = "No name"
    
    init(time: Date, price: Double, matchName: String) {
        self.time = time
        self.price = price
        self.matchName = matchName
    }
}

/////Stats for every player
struct statistic {
    var goal: Int = 0
    var assist: Int = 0
    var gamePlayed: Int = 0
    
}
