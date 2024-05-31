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
import CoreLocation

struct MapView: View {
    
    @State private var searchMapResult: [MKMapItem] = [MKMapItem]()
    //    @State private var positionRegion: MapCameraPosition = .automatic //Render
    
    //    @State private var markerSelector: MKMapItem?
    @State private var sheetSelectionDetails: Bool = false
    @State private var getDirections: Bool = false
    @State private var routeDisplaying: Bool = false //If a route is displaying
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var posizione = userLocationManager() //Retrive user location from MAPKIT class
    //    @State private var selectThisPlace: Bool = false
    
    @Binding var searchLocation: String
    @Binding var positionRegion: MapCameraPosition
    @Binding var markerSelector: MKMapItem?
    @Binding var selectThisPlace: Bool
    @Binding var latitude: Double
    @Binding var longitude: Double
    
    
    var body: some View {
        //Passing runtime data to map render
        Map(position: $positionRegion, selection: $markerSelector) {
            UserAnnotation()
            
            //Markers are used to display content at a specific coordinate on the map.
            //TODO: Open the map at user location
            //            Marker("Diego Armando Maradona Stadium", systemImage:"sportscourt",
            //                   coordinate: .userLocation)
            
            //Like Marker, Annotation is used to display content at a specific coordinate but displays a SwiftUI View.
            
            ForEach(searchMapResult, id: \.self) { result in
                //MARK: This code is usefull to understand oh to show things but when it is enabled the compiler is unable to type-check
                //                if routeDisplaying {
                //                    if result == routeDestination {
                //                        //Only show the selected placemark
                //                        let placemark = result.placemark
                //                        Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                //                    }
                //                } else {
                let placemark = result.placemark
                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                
                
                //                }
            }
            
            //            if let route {
            //                MapPolyline(route.polyline)
            //                    .stroke(.blue, lineWidth: 6)
            //            }
            
        }
        .mapStyle(.standard(elevation: .realistic))
        .onChange(of: searchMapResult) {
            positionRegion = .automatic
        }
        
        //Show search bar, add beheviour and sheetView
        
        .overlay(alignment: .bottom) {
            TextField("Search for a location", text: $searchLocation)
                .font(.subheadline)
                .padding(12) //increase searchbar size
                .background(.windowBackground)
                .padding() //separate from top screen section
                .shadow(radius: 10)
            
        }
        .onSubmit(of: .text) {
            Task { await searchPlaces() }
        }
        //        .onChange(of: getDirections, { oldValue, newValue in
        //            if newValue {
        //                fetchRoute()
        //            }
        //        })
        //Whenever we select an item, if newValue is not nil then show the value in sheet
        .onChange(of: markerSelector, { oldValue, newValue in
            sheetSelectionDetails = newValue != nil
            
        })
        .sheet(isPresented: $sheetSelectionDetails, content: { LocationDetailsView(markerSelector: $markerSelector, showSheet: $sheetSelectionDetails, getDirections: $getDirections, selectThisPlace: $selectThisPlace)
            //TODO: check documentation
                .presentationDetents([.height(340)])
            //Allow the user to interact whit the map when the view is presented
                .presentationBackgroundInteraction(.enabled(upThrough: .height(340)))
                .presentationCornerRadius(12)
        })
        .mapControls{
            MapCompass()
            MapUserLocationButton()
            MapPitchToggle()
        }
        .onChange(of: selectThisPlace) { oldValue, newValue in
            if newValue {
                updateCoordinates()
            }
        }
    }
}
//The search function uses MKLocalSearch to find places near the Boston Common parking garage, and writes the results using a binding.
extension MapView {
    func searchPlaces () async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchLocation
        //        request.resultTypes = .pointOfInterest
        //        request.region = .userRegion
        
        Task {
            let results = try? await MKLocalSearch(request: request).start()
            self.searchMapResult = results?.mapItems ?? []
            print("DEBUG: request ->>> \(request)")
            print("DEBUG: response ->>> \(results ?? MKMapItem())")
            print("DEBUG: searchlocation ---> \(searchLocation)")
            print("DEBUG: searchmapresult ---> \(searchMapResult)")
        }
        
        //        Task {
        //            let search = MKLocalSearch(request: request)
        //            print("DEBUG: search ->>> \(search)")
        //            let response = try? await search.start()
        //            print("DEBUG: response ->>> \(response!)")
        //            searchMapResult = response?.mapItems ?? []
        //        }
        //        print("DEBUG: searchlocation ---> \(searchLocation)")
        //
        //        print("DEBUG: searchmapresult ---> \(searchMapResult)")
        
    }
    private func updateCoordinates() {
        if let coordinate = markerSelector?.placemark.coordinate {
            latitude = coordinate.latitude
            longitude =  coordinate.longitude
            print("DEBUG: Coordinates updated: \(latitude), \(longitude)")
        } else {
            print("No coordinates to add")
        }
    }
    
    func fetchUserPosition() -> MKUserLocation {
        return posizione.userLocation
    }
    
    //    func fetchRoute() {
    //        if let markerSelector {
    //            let request = MKDirections.Request()
    //            request.source = MKMapItem(placemark: .init(coordinate: fetchUserPosition().coordinate)) //Start position for directions
    //            request.destination = markerSelector
    //
    //            Task {
    //                let result = try? await MKDirections(request: request).calculate()
    //                route = result?.routes.first //Array i think, check documentation
    //                routeDestination = markerSelector
    //
    //                withAnimation(.snappy) {
    //                    routeDisplaying = true
    //                    sheetSelectionDetails = false
    //
    //                    //TODO: check documentation for boundingMapRect
    //                    if let rect = route?.polyline.boundingMapRect, routeDisplaying {
    //                        positionRegion = .rect(rect)
    //
    //                    }
    //                }
    //            }
    //        }
    //    }
    
    
    
    //    static var userRegion: MKCoordinateRegion {
    //        return .init(center: posizione.userLocation.coordinate, latitudinalMeters: 15000, longitudinalMeters: 15000)
    //    }
}

//extension CLLocationCoordinate2D {
//    static var userLocation: CLLocationCoordinate2D {
//        return .init(latitude: 40.827965, longitude: 14.192947)
//    }
//}

//extension MKCoordinateRegion {
//    static var userRegion: MKCoordinateRegion {
//        return .init(center: posizione.userLocation, latitudinalMeters: 15000, longitudinalMeters: 15000)
//    }
//}

#Preview {
    MapView(searchLocation: .constant(""), positionRegion: .constant(.automatic), markerSelector: .constant(nil), selectThisPlace: .constant(false), latitude: .constant(0.000001), longitude: .constant(0.0000001))
}
