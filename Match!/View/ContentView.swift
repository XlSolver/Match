//
//  ContentView.swift
//  Match!
//
//  Created by Salvatore Flauto on 23/05/24.
//

import SwiftUI
import _MapKit_SwiftUI

struct ContentView: View {
    @AppStorage("log_Status") private var logStatus: Bool = false
    var body: some View {
        if logStatus {
            AllMatchView(position: .constant(MapCameraPosition.automatic), markerSelector: .constant(nil), searchLocation: .constant(""), price: .constant(0.0), lookAroundScene: .constant(nil), matchName: .constant(""), selectThisPlace: .constant(false), latitude: .constant(1.6), longitude: .constant(1.6), subscribers: .constant(0), date: .constant(.greatestFiniteMagnitude))
        } else {
            SignIn()
        }
    }
}

#Preview {
    ContentView()
}
