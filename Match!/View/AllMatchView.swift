//
//  ContentView.swift
//  Match!
//
//  Created by Salvatore Flauto on 27/11/23.
//

import SwiftUI
//import SwiftData
import MapKit
import Firebase

struct AllMatchView: View {
    @Environment (\.modelContext) private var context
    @AppStorage("log_Status") private var logStatus: Bool = false
    
    //    @Binding var player: Player
    //    @Binding var match: [Match]
    @Binding var position: MapCameraPosition
    @Binding var markerSelector: MKMapItem?
    @Binding var searchLocation: String
    @Binding var price: Double
    @Binding var lookAroundScene: MKLookAroundScene?
    @Binding var matchName: String
    @Binding var selectThisPlace: Bool
    @Binding var latitude: Double
    @Binding var longitude: Double
    @Binding var test: CLLocationCoordinate2D
    
    
    //    @Query (sort: \Match.time, animation: .smooth) var allMatchesInRange: [Match]
    
    @State private var IsShowingSheet: Bool = false
    
    //observed object with observable macro
    @State var rtDB: RTDB = RTDB()
    
    let match = Match()
    
    var body: some View {
        NavigationStack {
            List {
                Button("Logout") {
                    Task {
                        await signOut(info: Auth.auth())
                    }
                }
                //Show all match
                
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
                        NewMatchSheetView(test: $test)
                    }
                }
            }
            .navigationTitle("All match!")
            .task {
                await saveCurrentUserIdToDatabase()
            }
        }
    }
    
    func signOut(info: Auth) async {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
        print("LogStatus: \(logStatus)")
        print("Calling signOut")
        logStatus = false
        print("LogStatus: \(logStatus)")
        
    }
    
    func saveCurrentUserIdToDatabase() async {
        do {
//            try await self.rtDB.matchREF.child("users").child("userID").setValue(["ID": "\(Auth.auth().currentUser?.uid ?? "No id to display")"])
            
            try await self.rtDB.matchREF.child("users").child("userID").childByAutoId().setValue("\(Auth.auth().currentUser?.uid ?? "No id to display")")
            print("Data JSON id saved successfully!")
        } catch {
            print("ID Data could not be saved: \(error.localizedDescription).")
        }
    }
    
    func readFromDatabaseNumberPlayerForMatch() async {
        do {
            try await self.rtDB.matchREF.child("ID").observe(.value, with: { snapshot in
                
                if let value = snapshot.value as? Int {
                    let matchSubscribers = Match(subscribers: Int(snapshot.childrenCount))
                }
            })
        } catch {
            print("Can't read from database: \(error.localizedDescription).")
        }
    }
    func readFromDatabaseMatchAmount() -> Int {
        
        Int(
            rtDB.matchREF.observe(DataEventType.value, with: { snapshot in
                let reference = snapshot.ref
                let value = snapshot.value
                //                let match = Match().id.count
            }))
    }
    
    func showAllMatch() {
        
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
    AllMatchView(position: .constant(MapCameraPosition.automatic), markerSelector: .constant(nil), searchLocation: .constant(""), price: .constant(0.0), lookAroundScene: .constant(nil), matchName: .constant(""), selectThisPlace: .constant(false), latitude: .constant(1.5), longitude: .constant(1.5), test: .constant(.init(latitude: 10.1, longitude: 10.1)))
}
