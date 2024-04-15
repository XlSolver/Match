//
// NewMatchSheetView.swift
// Match!
//
// Created by Salvatore Flauto on 10/02/24.
//

import SwiftUI
import SwiftData
import MapKit

/// Sheet view that enables the user to create a new match
struct NewMatchSheetView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    
    @State private var matchName: String = ""
    @State private var date = Date()
    @State private var price: Double = 0.0
    @State private var priceString: String = ""
    @State private var selectedField: Location? = nil // Holds selected field data
    @State private var searchMapResult: [MKMapItem] = [] //State to keep track of the search results.
    @State private var isShowingMap = false
    
    @Binding var searchLocation: String
    @Binding var position: MapCameraPosition
    @Binding var markerSelector: MKMapItem?
    
    //To add done button on top of keyboard
    @FocusState private var keyboardFocused: Bool
    
    
    
    var body: some View {
        
        //    @StateObject var locationManager: LocationManager = .init()
        
        ///MARK: Navigation tag to push view to mapView
        
        
        NavigationView {
            List {
                Section {
                    TextField("Match Name", text: $matchName)
                        .autocorrectionDisabled(true)
                        .textFieldStyle(.automatic)
                        .focused($keyboardFocused)
                        
                    
                    
                    TextField("0,00€", value: $price, format: .currency(code: "EUR"))
                        .keyboardType(.decimalPad)
                        .textFieldStyle(.automatic)
                        .focused($keyboardFocused)
                        
                        
                    
                }
                Section {
                    DatePicker("Date & Time", selection: $date, displayedComponents: [.date, .hourAndMinute])
                }
                MapView()
                    .scaledToFill()
                    .clipShape(.rect(cornerRadius: 10))
            }
            .toolbar {
                ToolbarItem {
                    Button(action: saveMatch) {
                        Text("Create Match")
                    }
                    .disabled(
                        matchName.isEmpty || price.isNaN || price.isLessThanOrEqualTo(0.0) /*|| selectedField == nil*/
                    )
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button(action: { keyboardFocused = false }) {
                        Text("Done")
                    }
                }
            }
//            Section {
                //DispatchConcurrentQueue. TODO: CAPIRE COME CARICARE LE COSE IN ALTRI THREAD
                
//            }
        }
    }
    
    private func saveMatch() {
        guard let selectedField = selectedField else {
            // Handle the case where no field is selected
            print("Ciao")
            //la funzione si blocca qui perché non riesce a prendere i dati della posizione e quindi non salva e non chiude la modale
            return
        }
        
        
        
//        let newMatch = Match(
//            fieldLatitude: selectedField.coordinate.latitude,
//            fieldLongitude: selectedField.coordinate.longitude,
//            time: date,
//            price: price,
//            matchName: matchName
//        )
        
        do {
            print("Cane")
            context.insert(newMatch)
            try context.save()
            print("Match created successfully!")
            dismiss()
        } catch let error as NSError {
            print("Error creating match: \(error.localizedDescription)")
            print("Error code: \(error.code)")
            
            //      // Show an alert to the user with error details
            //      let alert = Alert(title: Text("Error"), message: Text(error.localizedDescription), dismissButton: .default(Text("OK")))
            //      present(alert, animated: true)
        }
    }
}



// Model for field data (replace with your actual field data structure)
struct Location {
    let name: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let region: MKCoordinateRegion // May be derived from coordinate
}

#Preview {
    NewMatchSheetView(searchLocation: .constant("vesuvio"), position: .constant(MapCameraPosition.automatic), markerSelector: .constant(nil))
        .modelContainer(for: Match.self)
}
