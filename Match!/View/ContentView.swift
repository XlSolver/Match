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
            AllMatchView(position: .constant(MapCameraPosition.automatic), markerSelector: .constant(nil), searchLocation: .constant(""), price: .constant(0.0), lookAroundScene: .constant(nil), matchName: .constant(""), selectThisPlace: .constant(false), latitude: .constant(1.6), longitude: .constant(1.6), test: .constant(.init(latitude: 11.1, longitude: 11.1)))
        } else {
            SignIn()
        }
    }
}

#Preview {
    ContentView()
}
