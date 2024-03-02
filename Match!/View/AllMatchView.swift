//
//  ContentView.swift
//  Match!
//
//  Created by Salvatore Flauto on 27/11/23.
//

import SwiftUI
import SwiftData
import MapKit

struct AllMatchView: View {
    @Environment (\.modelContext) private var context
    
    @Binding var player: Player
    @Binding var match: [Match]
    @Binding var position: MapCameraPosition
    
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
                        NewMatchSheetView(position: $position)
                    }
                }
            }
            .navigationTitle("All match!")
        }
    }
}

#Preview {
    AllMatchView(player: .constant(Player(name: "", surname: "", age: 0, skillLevel: 0, profilePicture: Data())), match: .constant([Match]()), position: .constant(MapCameraPosition.automatic))
        .modelContainer(for: Match.self)
}
