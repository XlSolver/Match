//
// NewMatchSheetView.swift
// Match!
//
// Created by Salvatore Flauto on 10/02/24.
//

import SwiftUI
import SwiftData
import MapKit
import FirebaseAuth

/// Sheet view that enables the user to create a new match
struct NewMatchSheetView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var matchName: String = ""
    @State private var date = Date()
    @State private var price: Double = 0.0
    @State private var priceString: String = ""
    @State private var searchMapResult: [MKMapItem] = [] //State to keep track of the search results.
    @State private var isShowingMap = false
    //observed object with observable macro
    @State var rtDB: RTDB = RTDB()
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State var latitude: Double = 0.0
    @State var longitude: Double = 0.0
    
    @Binding var test: CLLocationCoordinate2D
    
    @State var searchLocation: String = ""
    @State var position: MapCameraPosition = .automatic
    @State var markerSelector: MKMapItem?
    @State var selectThisPlace: Bool = false
    
    //To add done button on top of keyboard
    @FocusState private var keyboardFocused: Bool
    
    
    var body: some View {
        
        
        ///MARK: Navigation tag to push view to mapView
        
        
        NavigationView {
            List {
                Section {
                    TextField("Match Name", text: $matchName)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(.automatic)
                        .focused($keyboardFocused)
                    
                    
                    
                    TextField("0,00€", value: $price, format: .currency(code: "EUR"))
                        .keyboardType(.asciiCapableNumberPad)
                        .textFieldStyle(.automatic)
                        .focused($keyboardFocused)
                }
                Section {
                    DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                MapView(searchLocation: $searchLocation, positionRegion: $position, markerSelector: $markerSelector, selectThisPlace: $selectThisPlace, latitude: $latitude, longitude: $longitude)
                    .scaledToFill()
                    .clipShape(.rect(cornerRadius: 10))
            }
            .toolbar {
                ToolbarItem {
                    Button {
                        Task {
                            await saveMatch()
                        }
                    } label: {
                        Text("Create match")
                    }
                    .disabled(
                        matchName.isEmpty || price.isNaN || price.isLessThanOrEqualTo(0.0) /*|| markerSelector == nil*/
                    )
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(action: { keyboardFocused = false }) {
                        Text("Close")
                    }
                }
            }
            Section {
                //DispatchConcurrentQueue. TODO: CAPIRE COME CARICARE LE COSE IN ALTRI THREAD
                
            }
            .alert(isPresented: $showErrorAlert) {
                            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
                        }
        }
        //TODO: Inserire questo check per verificare l'inserimento di un posto e assegnarlo
//        .onChange(of: selectThisPlace) { oldValue, newValue in
//            print("DIOPORCOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO")
//            if newValue {
//                updateCoordinates()
//            }
//        } 
//        .onChange(of: markerSelector) { oldValue, newValue in
//            print("markerSelector changed to \(String(describing: newValue))")
//            if selectThisPlace {
//                updateCoordinates()
//            }
//        }
    }
    
    
    
    private func saveMatch() async {
        //TODO: Handle error
        print("DEBUG: Saving match with coordinates: \(latitude), \(longitude)")
        let newMatch = Match(
            fieldLatitude: latitude, //TODO: Handle the error
            fieldLongitude: longitude, //TODO: Handle the error
            time: date,
            price: price,
            matchName: matchName
        )
        
        do {
            print("DEBUG: Provo a mettere l'istanza nel db")
            
            try await self.rtDB.matchREF.child("users").child("userID").child("create match").childByAutoId().setValue("\(newMatch)")
            print("Data JSON user test saved successfully!")
            print("Match created successfully!")
            dismiss()
        } catch let error as NSError {
            print("Error creating match: \(error.localizedDescription)")
            print("Error code: \(error.code)")
            // Show an alert to the user with error details
            //            let alert = Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
            //                  present(alert, animated: true)
        }
    }
}


#Preview {
    NewMatchSheetView(test: .constant(.init(latitude: 0.0, longitude: 0.0)))
    //        .modelContainer(for: Match.self)
}
