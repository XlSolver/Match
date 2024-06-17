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
import FirebaseDatabaseSwift
import FirebaseDatabaseInternal

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
    @Binding var subscribers: Int
    @Binding var date: TimeInterval
    
    
    
    //    @Query (sort: \Match.time, animation: .smooth) var allMatchesInRange: [Match]
    
    @State private var IsShowingSheet: Bool = false
    
    //observed object with observable macro
    @State var rtDB: RTDB = RTDB()
    
    
    var body: some View {
        NavigationStack {
            if !RTDB.listMatchObject.isEmpty {
                VStack {
                    ForEach(RTDB.listMatchObject, id: \.self) { object in
                        NavigationLink(destination: MatchElementView(price: price, latitude: $latitude, longitude: $longitude, matchName: $matchName)){
                            Text(object.idCreatorOfMatch ?? "No creator")
                            Text(object.matchName)
                            
                        }
                        
                    }
                    .padding()
                    
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
                            NewMatchSheetView()
                        }
                    }
                }
                .navigationTitle("All match!")
//                .task {
//                    await saveCurrentUserIdToDatabase()
//                }
                
            } else {
                Text("DEBUG: listMatchObject is empty.")
            }
        }
        .onAppear {
            showAllMatch()
        }
    }
    
    //TODO: SHIMMERVIEW()
    
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
    
    //    func readFromDatabaseNumberPlayerForMatch() async {
    //        do {
    //            try await self.rtDB.matchREF.child("ID").observe(.value, with: { snapshot in
    //
    //                if let value = snapshot.value as? Int {
    //                    let matchSubscribers = Match(subscribers: Int(snapshot.childrenCount))
    //                }
    //            })
    //        } catch {
    //            print("Can't read from database: \(error.localizedDescription).")
    //        }
    //    }
    func readFromDatabaseMatchAmount() {
        rtDB.matchREF.child("users").child("matchList").observeSingleEvent(of: .value) { snapshot in
            self.rtDB.matchObject = snapshot.value as? Match
        }
    }
    
    func showAllMatch(){
        let userID = Auth.auth().currentUser?.uid
        rtDB.matchREF.child("users").child("matchList").observe(.value, with: { snapshot in
            
            var value = snapshot.value as? NSDictionary
            print(value?.allKeys)
            
            let matchName = value?["matchName"] as? String ?? "No match name found"
            let price = value?["price"] as? Double ?? 0.0
            let latitude = value?["latitude"] as? Double ?? 0.0
            let longitude = value?["longitude"] as? Double ?? 0.0
            
            rtDB.matchObject?.matchName = matchName
            rtDB.matchObject?.price = price
            rtDB.matchObject?.fieldLatitude = latitude
            rtDB.matchObject?.fieldLongitude = longitude
            rtDB.matchObject?.idCreatorOfMatch = Auth.auth().currentUser?.uid
            rtDB.matchObject?.idPlayerThatWantsToPlay = "0"
            rtDB.matchObject?.subscribers = subscribers
            rtDB.matchObject?.time = 0.0
            
//            ForEach (rtDB.matchObject, id: \.self) { item in
            RTDB.listMatchObject.append(rtDB.matchObject ?? Match())
//            }
            
            
        }) { error in
            error.localizedDescription
        }
    }
    
//    func showAllMatch() {
//        rtDB.matchREF.child("users").child("userID").child("create match").observe(.value) { (snapshot: DataSnapshot) in
//            print("Snapshot: \(snapshot)")
//            guard let value = snapshot.value else {
//                print("DEBUG: Il nodo non contiene elementi.")
//                return
//            }
//            guard let dictionary = value as? [String: Any] else {
//                print("DEBUG: Il nodo non è un dizionario.")
//                return
//            }
//            for (key, value) in dictionary {
//                print("DEBUG: Leggo i valori di \(key)")
//                guard let dictionaryValue = value as? [String: Any] else {
//                    print("DEBUG: i dati di \(key) non sono un dizionario")
//                    return
//                }
//                let matchName = dictionaryValue[matchName] as! String
//                let price = dictionaryValue[price] as! Double
//                let latitude = dictionaryValue[latitude] as! Double
//                let longitude = dictionaryValue[longitude] as! Double
//            }
//            var matches: [Match] = []
//            for child in snapshot.children.allObjects as! [DataSnapshot] {
//                let userID = child.key
//                print("UserID: \(userID)")
//                guard let matchDict = child.value as? [String: Any] else {
//                    print("No match dict")
//                    continue
//                }
//                do {
//                    let match = try JSONDecoder().decode(Match.self, from: JSONSerialization.data(withJSONObject: matchDict))
//                    print("Decoded match: \(match)")
//                    matches.append(match)
//                } catch {
//                    print("Error decoding match: \(error)")
//                }
//            }
//            self.rtDB.listMatchObject = matches
//            print("listMatchObject count: \(rtDB.listMatchObject.count)")
        }
//    }
    
    
    
    //    func deleteMatches(at offsets: IndexSet) {
    //        match.remove(atOffsets: offsets)
    //        do {
    //            try context.delete(model: Match.self)
    //        } catch {
    //            print("Failed to delete all schools.")
    //        }
    //        }
//}

#Preview {
    //    AllMatchView(player: .constant(Player(name: "", surname: "", age: 0, skillLevel: 0, profilePicture: Data())), match: .constant([Match]()), position: .constant(MapCameraPosition.automatic), markerSelector: .constant(nil), searchLocation: .constant(""), price: .constant(0.0), lookAroundScene: .constant(nil), matchName: .constant(""))
    //        .modelContainer(for: Match.self)
    AllMatchView(position: .constant(MapCameraPosition.automatic), markerSelector: .constant(nil), searchLocation: .constant(""), price: .constant(0.0), lookAroundScene: .constant(nil), matchName: .constant(""), selectThisPlace: .constant(false), latitude: .constant(1.5), longitude: .constant(1.5), subscribers: .constant(0), date: .constant(.greatestFiniteMagnitude))
}
