//
//  GoogleMapViewController.swift
//  MapKit_2_10
//
//  Created by Лаура Есаян on 01.04.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import UIKit
import GoogleMaps

class GoogleMapViewController: UIViewController {
    @IBOutlet weak var mapView: GMSMapView!
    private var landmarks: [Landmark] = []
    private var markers: [Marker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        loadLandmarks(landmarks: &landmarks)
        
        for landmark in landmarks {
            let marker = Marker(place: landmark)
            marker.map = self.mapView
            markers.append(marker)
        }
        
//        mapView.camera = GMSCameraPosition(latitude: 55.7522200, longitude: 37.6155600, zoom: 15)
        mapView.camera = GMSCameraPosition(latitude: markers[0].place.coordinate.latitude, longitude: markers[0].place.coordinate.longitude, zoom: 15)

    }
}

extension GoogleMapViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if let snippet = marker.snippet {
            print(snippet)
        }
        return false
    }
    
    
}
