//
//  ContentView.swift
//  Match!
//
//  Created by Salvatore Flauto on 27/11/23.
//

import SwiftUI
import SwiftData

struct AllMatchView: View {
    @Environment (\.modelContext) private var context
    
    @Binding var player: Player
    @Binding var match: [Match]
    
    //It makes the app crash
    @Query var allMatchesInRange: [Match]
    
    @State private var IsShowingSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                
                //lista dei match
                ForEach(allMatchesInRange) { item in
//                    NavigationLink(destination: MatchElementView(player: $player)) {
//                        
//                    }
                    VStack(alignment: .leading) {
                        Text(item.matchName)
                            .font(.headline)
                    }
                }
                
            }
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button {
                        IsShowingSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $IsShowingSheet){
                        NewMatchSheetView()
                    }
                }
            }
            .navigationTitle("All match!")
        }
    }
}

#Preview {
    AllMatchView(player: .constant(Player(name: "", surname: "", age: 0, skillLevel: 0, profilePicture: Data())), match: .constant([Match]()))
        .modelContainer(for: Match.self)
}
