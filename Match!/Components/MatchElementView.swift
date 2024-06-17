//
//  MatchElementView.swift
//  Match!
//
//  Created by Salvatore Flauto on 06/02/24.
//

import SwiftUI
import MapKit
import SwiftData

struct MatchElementView: View {
    
    //    @Binding var player: Player
    var markerSelector: MKMapItem?
    var price: Double
    @Binding var latitude: Double
    @Binding var longitude: Double
    @Binding var matchName: String
    
    //    @Binding var match: [Match]
    @State var rtDB: RTDB = RTDB()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .foregroundStyle(.regularMaterial)
            //singolo match con le informazioni relative
            VStack {
                //TODO: to fix money that doesn't come from general database
                Text("\(price, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))")
                
            }
        }
        .onAppear {
            readFromDatabaseMatchDetails()
        }
    }
    
    
    func readFromDatabaseMatchDetails() {
        rtDB.matchREF.child("users").child("\($matchName)").observeSingleEvent(of: .value) { snapshot in
            
            var value = snapshot.value as? NSDictionary
            print(value?.allKeys)
            
            let price = value?["price"] as? Double ?? 0.0
            let latitude = value?["latitude"] as? Double ?? 0.0
            let longitude = value?["longitude"] as? Double ?? 0.0
            
            
        }
    }
}

#Preview {
    MatchElementView(price: 0.0, latitude: .constant(0.0), longitude: .constant(0.0), matchName: .constant(""))
}
