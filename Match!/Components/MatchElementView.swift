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
    @Binding var lookAroundScene: MKLookAroundScene?
    var matchName: String
    
//    @Binding var match: [Match]
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
            .foregroundStyle(.regularMaterial)
            //singolo match con le informazioni relative
            VStack {
                //TODO: to fix money that doesn't come from general database
                Text("\(price, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))")
//                    var luogo = markerSelector?.openInMaps()
                if let scene = lookAroundScene {
                        //Generate the scene with this parameters
                        LookAroundPreview(initialScene: scene)
                            .frame(height: 200)
                            .presentationCornerRadius(12)
                            .padding()
                    } else {
                        ContentUnavailableView("No preview available", systemImage: "eye.slash")
                }
            }
        }
    }
}

#Preview {
    MatchElementView(price: 0.0, lookAroundScene: .constant(nil), matchName: ""/*, match: .constant([Match]())*/)
}
