//
//  MapView.swift
//  Match!
//
//  Created by Salvatore Flauto on 02/03/24.
//
//  This was made possible thanks to WWDC 2024 MapKit for SwiftUI
//  See also https://www.wwdcnotes.com/notes/wwdc23/10043/
//  Most of the code here was taken from https://www.youtube.com/watch?v=gy6rp_pJmbo&t=10s


import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var searchMapResult: [MKMapItem] = [MKMapItem]()
    @State private var positionRegion: MapCameraPosition = .automatic
    @State private var searchLocation: String = ""
    @State private var mapSelection: MKMapItem?
    
    var body: some View {
        Map(position: $positionRegion, selection: $mapSelection) {
            UserAnnotation()
            
            //Markers are used to display content at a specific coordinate on the map.
            Marker("Diego Armando Maradona Stadium", systemImage:"sportscourt",
                   coordinate: .MaradonaStadium)
            
            //Like Marker, Annotation is used to display content at a specific coordinate but displays a SwiftUI View.
            
            ForEach(searchMapResult, id: \.self) { result in
                let placemark = result.placemark
                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
            }
            
            
        }
        .mapStyle(.standard(elevation: .realistic))
        .onChange(of: searchMapResult) {
            positionRegion = .automatic
        }
        
        //Show search bar
        //TO DO: 
        .overlay(alignment: .bottom) {
            TextField("Search for a location", text: $searchLocation)
                .font(.subheadline)
                .padding(12) //increase searchbar size
                .background(.windowBackground)
                .padding() //separate from top screen section
                .shadow(radius: 10)
        }
        .onSubmit(of: .text) {
            Task { await search() }
        }
        .onChange(of: mapSelection, { oldValue, newValue in
            
        })
        .mapControls{
            MapCompass()
            MapUserLocationButton()
            MapPitchToggle()
        }
            
    }
    
    //The search function uses MKLocalSearch to find places near the Boston Common parking garage, and writes the results using a binding.
    private func search () async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchLocation
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
    MapView()
}
