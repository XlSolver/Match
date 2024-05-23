//
//  ContentView.swift
//  Match!
//
//  Created by Salvatore Flauto on 27/11/23.
//

import SwiftUI
//import SwiftData
import MapKit

struct AllMatchView: View {
    @Environment (\.modelContext) private var context
    
//    @Binding var player: Player
//    @Binding var match: [Match]
    @Binding var position: MapCameraPosition
    @Binding var markerSelector: MKMapItem?
    @Binding var searchLocation: String
    @Binding var price: Double
    @Binding var lookAroundScene: MKLookAroundScene?
    @Binding var matchName: String
    
    
//    @Query (sort: \Match.time, animation: .smooth) var allMatchesInRange: [Match]
    
    @State private var IsShowingSheet: Bool = false
    
    
    var body: some View {
        NavigationStack {
            List {
                //lista dei match
//                ForEach(allMatchesInRange) { item in
//                    NavigationLink(destination: MatchElementView(markerSelector: markerSelector, price: item.price, lookAroundScene: $lookAroundScene, matchName: item.matchName, match: $match)) {
//                        HStack {
//                            Text(item.matchName)
//                                .font(.headline)
//                                .presentationCornerRadius(10)
//                            Text("\(item.price, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))")
//                            
//                        }
//                    }
//                    //                    if !allMatchesInRange.isEmpty {
//                    //                        VStack(alignment: .leading) {
//                    //                            Text(item.matchName)
//                    //                                .font(.headline)
//                    //                        }
//                    //                    } else {
//                    //
//                    //                    }
//                    .swipeActions {
//                        Button("Delete", systemImage: "trash", role: .destructive) {
//                            context.delete(item)
//                            print("DEBUG: Item deleted")
//                        }
//                    }
//                    
//                }
//                .onDelete(perform: deleteMatches)
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
    
//    func deleteMatches(at offsets: IndexSet) {
//        match.remove(atOffsets: offsets)
//        do {
//            try context.delete(model: Match.self)
//        } catch {
//            print("Failed to delete all schools.")
//        }
//    }
}

#Preview {
//    AllMatchView(player: .constant(Player(name: "", surname: "", age: 0, skillLevel: 0, profilePicture: Data())), match: .constant([Match]()), position: .constant(MapCameraPosition.automatic), markerSelector: .constant(nil), searchLocation: .constant(""), price: .constant(0.0), lookAroundScene: .constant(nil), matchName: .constant(""))
//        .modelContainer(for: Match.self)
    AllMatchView(position: .constant(MapCameraPosition.automatic), markerSelector: .constant(nil), searchLocation: .constant(""), price: .constant(0.0), lookAroundScene: .constant(nil), matchName: .constant(""))
}
