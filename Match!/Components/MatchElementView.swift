//
//  MatchElementView.swift
//  Match!
//
//  Created by Salvatore Flauto on 06/02/24.
//

import SwiftUI

struct MatchElementView: View {
    
    @Binding var player: Player
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(.regularMaterial)
            //singolo match con le informazioni relative
            VStack {
                HStack {
                    Text(player.name)
                    Text(player.surname)
                }
            }
        }
    }
}

#Preview {
    MatchElementView(player: .constant(Player(name: "Cadrega", surname: "Inganno", age: 0, skillLevel: 0, profilePicture: Data())))
}
