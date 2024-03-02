//
//  LocationManager.swift
//  Match!
//
//  Created by Salvatore Flauto on 28/02/24.
//

import Foundation
import CoreLocation
import MapKit
//import Observation
///MARK: Combine framework to watch Textfield Change
import Combine

//@Observable
class LocationManager: NSObject, MKMapViewDelegate, ObservableObject, CLLocationManagerDelegate{
    
    ///MARK: properties
    @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()
    
    ///MARK: Searchbar text
    @Published var searchText: String = ""
    var cancellable: AnyCancellable?
    @Published var fetchedPlaces: [MKPlacemark]?
    
    
    override init() {
        super.init()
        ///MARK:  Setting delegates
        mapView.delegate = self
        manager.delegate = self
        
      
        ///MARK: Requesting Location access
        manager.requestWhenInUseAuthorization()
        
        ///MARK: Search textfield Watching
        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink(receiveValue: { value in
                if value != "" {
                    self.fetchPlaces(value: value)
                } else {
                    self.fetchedPlaces = nil
                }
            })
    }
    
    func fetchPlaces(value: String) {
        ///MARK: Fetching places using MKLocalSearch & Async/Await
        Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = value.lowercased()
                
                let response = try await MKLocalSearch(request: request).start()
                //We can also use Mainactor to publish changes in main thread
                await MainActor.run(body: {
                    self.fetchedPlaces = response.mapItems.compactMap ({ item -> MKPlacemark in
                        print("Funzionaaaaaaa")
                        return item.placemark
                    })
                })
            } catch {
                //HANDLE ERROR
                print("Non funzionaaaaaaaaaa")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // HANDLE ERROR
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let _ = locations.last else { return }
    }
    
    ///MARK: Location authorization
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways: manager.requestLocation()
        case .authorizedWhenInUse: manager.requestLocation()
        case .denied: handleLocationError()
        case .notDetermined: manager.requestWhenInUseAuthorization()
        default: ()
        }
    }
    
    func handleLocationError() {
        // HANDLE ERROR
    }
}
