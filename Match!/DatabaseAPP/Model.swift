//
//  Model.swift
//  Match!
//
//  Created by Salvatore Flauto on 27/11/23.
//

import Foundation
import SwiftData
import SwiftUI

/////Class that identify the entity player (Persistent data)
@Model
final class Player: Identifiable {
    var id = UUID()
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
/////The generic structure for a team
@Model
class Team {
    var name: String
    var teamMember: Player
    
    init(name: String, teamMember: Player) {
        self.name = name
        self.teamMember = teamMember
    }
}
/////Class that create an object for a match (Persistent data)
@Model
final class Match {
    var field: String //test need to check
    var teamHome: Team
    var teamOspite: Team
    var time: Date
    var price: Float
    
    init(field: String, teamHome: Team, teamOspite: Team, time: Date, price: Float) {
        self.field = field
        self.teamHome = teamHome
        self.teamOspite = teamOspite
        self.time = time
        self.price = price
    }
}

/////Stats for every player
struct statistic {
    var goal: Int
    var assist: Int
    var gamePlayed: Int
    
}
