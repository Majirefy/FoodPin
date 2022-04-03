//
//  MapView.swift
//  FoodPin
//
//  Created by Fangcheng Song on 2022/3/17.
//

import SwiftUI
import MapKit

struct MapView: View {
    var address = ""
    
    @State private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    @State private var annotatedItem = AnnotatedItem(locationCoordinate2D: CLLocationCoordinate2D(latitude: 51.510357, longitude: -0.116773))
    
    var body: some View {
        Map(coordinateRegion: $coordinateRegion, interactionModes: [], annotationItems: [annotatedItem]) { annotatedItem in
            MapMarker(coordinate: annotatedItem.locationCoordinate2D, tint: .red)
        }
        .task {
            convertAddress(address: address)
        }
    }
    
    private func convertAddress(address: String) {
        let geoCoder = CLGeocoder()
        
        geoCoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let placemarks = placemarks, let location = placemarks[0].location else {
                return
            }
            coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015))
            annotatedItem = AnnotatedItem(locationCoordinate2D: location.coordinate)
        }
    }
    
    struct AnnotatedItem: Identifiable {
        let id = UUID()
        var locationCoordinate2D: CLLocationCoordinate2D
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(address: "古槐名邸6号楼")
            .previewLayout(.sizeThatFits)
    }
}
