import SwiftUI
import MapKit

struct LocationDetailsView: View {
    
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var test: CLLocationCoordinate2D?
    
    @Binding var markerSelector: MKMapItem?
    @Binding var showSheet: Bool
    @Binding var getDirections: Bool
    @Binding var selectThisPlace: Bool
    
    
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
            
            if let scene = lookAroundScene {
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
                    selectThisPlace = true
                    showSheet = false
                    print("LocationDetailsView: Select this place clicked. selectThisPlace set to \(selectThisPlace)")
                } label: {
                    Text("Select this place")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(width: 170, height: 48)
                        .background(.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .onAppear {
            print("LocationDetailsView: Did call on appear")
            fetchLookAroundPreview()
        }
        .onChange(of: markerSelector) { oldValue, newValue in
            print("LocationDetailsView: Did call on change")
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
    LocationDetailsView(markerSelector: .constant(nil), showSheet: .constant(false), getDirections: .constant(false), selectThisPlace: .constant(false))
}
