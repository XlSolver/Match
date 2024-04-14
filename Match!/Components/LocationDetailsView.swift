//
//  LocationDetailsView.swift
//  Match!
//
//  Created by Salvatore Flauto on 05/03/24.
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    
    @State private var lookAroundScene: MKLookAroundScene?
    
    @Binding var markerSelector: MKMapItem?
    @Binding var showSheet: Bool
    @Binding var getDirections: Bool
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(markerSelector?.placemark.name ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text(markerSelector?.placemark.title ?? "")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .lineLimit(12)
                        .padding(.trailing)
                }
                Spacer()
                
                Button {
                    showSheet.toggle()
                    markerSelector = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.gray, Color(.systemGray6))
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            //Look around in sheet view
            if let scene = lookAroundScene {
                //Generate the scene with this parameters
                LookAroundPreview(initialScene: scene)
                    .frame(height: 200)
                    .presentationCornerRadius(12)
                    .padding()
            } else {
                ContentUnavailableView("No preview available", systemImage: "eye.slash")
            }
            HStack(spacing: 24) {
                Button {
                    if let markerSelector {
                        markerSelector.openInMaps()
                    }
                } label: {
                    Text("Open in Maps")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 170, height: 48)
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 12.0))
                }
                
                Button {
                        getDirections = true
                        showSheet = false
                } label: {
                    Text("Get directions")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .onAppear {
            print("DEBUG: Did call on appear")
            fetchLookAroundPreview()
        }
        .onChange(of: markerSelector) { oldValue, newValue in
            print("DEBUG: Did call on change")
            fetchLookAroundPreview()
        }
        .padding()
    }
}

extension LocationDetailsView {
    func fetchLookAroundPreview() {
        if let markerSelector {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: markerSelector)
                lookAroundScene = try? await request.scene
            }
        }
    }
}

#Preview {
    LocationDetailsView(markerSelector: .constant(nil), showSheet: .constant(false), getDirections: .constant(false))
}
