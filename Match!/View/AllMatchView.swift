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
    @Binding var markerSelector: MKMapItem?
    @Binding var searchLocation: String
    
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
                    if !allMatchesInRange.isEmpty {
                        VStack(alignment: .leading) {
                            Text(item.matchName)
                                .font(.headline)
                        }
                    } else {
                        
                    }
                }
                
            }
            .task{
                CLLocationManager().requestWhenInUseAuthorization()
            }
            .toolbar {
                ToolbarItemGroup(placement: .automatic) {
                    Button {
                        IsShowingSheet.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                    .sheet(isPresented: $IsShowingSheet){
                        NewMatchSheetView(searchLocation: $searchLocation, position: $position, markerSelector: $markerSelector)
                    }
                }
            }
            .navigationTitle("All match!")
        }
    }
}

#Preview {
    AllMatchView(player: .constant(Player(name: "", surname: "", age: 0, skillLevel: 0, profilePicture: Data())), match: .constant([Match]()), position: .constant(MapCameraPosition.automatic), markerSelector: .constant(nil), searchLocation: .constant("") )
        .modelContainer(for: Match.self)
}
