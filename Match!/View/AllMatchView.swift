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
    
    @State private var IsShowingSheet: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                List(match) { item in
                    NavigationLink(destination: MatchElementView(player: $player)) {
                        
                    }
                    //lista dei match
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
                        SheetView()
                    }
                }
            }
            .navigationTitle("All match!")
        }
    }
}

#Preview {
    AllMatchView(player: .constant(Player(name: "", surname: "", age: 0, skillLevel: 0, profilePicture: Data())), match: .constant([Match]()))
}
///Sheet view that enables the user to create a new match
struct SheetView: View {
    @Environment (\.dismiss) var dismiss
    
    var body: some View {
        Text("test")
    }
}
