//
//  MapView.swift
//  Match!
//
//  Created by Salvatore Flauto on 02/03/24.
//
//  This was made possible thanks to WWDC 2024 MapKit for SwiftUI
//  See also https://www.wwdcnotes.com/notes/wwdc23/10043/


import SwiftUI
import MapKit

struct MapView: View {
    
    @Binding var searchMapResult: [MKMapItem]
    
    @State private var position: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $position) {
            //Markers are used to display content at a specific coordinate on the map.
            Marker("Diego Armando Maradona Stadium", systemImage:"sportscourt",
                   coordinate: .MaradonaStadium)
            
            //Like Marker, Annotation is used to display content at a specific coordinate but displays a SwiftUI View.
            
            ForEach(searchMapResult, id: \.self) { result in
                Marker(item: result)
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .onChange(of: searchMapResult) {
            position = .automatic
        }
            
    }
    
    //The search function uses MKLocalSearch to find places near the Boston Common parking garage, and writes the results using a binding.
    private func search (for query: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(center: .MaradonaStadium, span: MKCoordinateSpan(latitudeDelta: 0.125, longitudeDelta: 0.125)
        )
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchMapResult = response?.mapItems ?? []
        }
    }
    
}

extension CLLocationCoordinate2D {
    static let MaradonaStadium = CLLocationCoordinate2D(
        latitude: 40.827965, longitude: 14.192947
    )
}

#Preview {
    MapView(searchMapResult: .constant([MKMapItem]()))
}
