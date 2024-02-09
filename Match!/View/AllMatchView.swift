//
//  ContentView.swift
//  Match!
//
//  Created by Salvatore Flauto on 27/11/23.
//

import SwiftUI

struct AllMatchView: View {
    
    @Binding var player: Player
    
    var body: some View {
        NavigationStack {
//                VStack {
                    ScrollView(.horizontal) {
                    ForEach(0 ..< 3) { item in
                    
                        MatchElementView(player: $player)
                    }
                }
                .toolbar {
                    ToolbarItemGroup(placement: .automatic) {
                    }
                }
                .navigationTitle("All match!")
            }
        }
    }
//}

#Preview {
    AllMatchView(player: .constant(Player(name: "", surname: "", age: 0, skillLevel: 0, profilePicture: Data())))
}
