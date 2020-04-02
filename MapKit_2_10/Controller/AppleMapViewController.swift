//
//  AppleMapViewController.swift
//  MapKit_2_10
//
//  Created by Лаура Есаян on 01.04.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import UIKit
import MapKit

class AppleMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    fileprivate let locationManager = CLLocationManager()
    private var landmarks: [Landmark] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        askPermissions()

        // Наведение камеры на положение пользователя.
//        mapView.userTrackingMode = MKUserTrackingMode.follow
        mapView.register(LandmarkMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        loadLandmarks()
        mapView.addAnnotations(landmarks)
        
        let marker = CLLocation(latitude: landmarks[0].coordinate.latitude, longitude: landmarks[0].coordinate.longitude)
        restrictRegion(around: marker)
    }
    
    func askPermissions() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
    }
    
    // Oграничения на регион и центрирование вокруг заданной координаты.
    func restrictRegion(around coordinates: CLLocation) {
        mapView.centerToLocation(coordinates)
        
        let region = MKCoordinateRegion(center: coordinates.coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapView.setCameraBoundary(MKMapView.CameraBoundary(coordinateRegion: region), animated: true)

        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 2000)
        mapView.setCameraZoomRange(zoomRange, animated: true)
    }
    
    // Загрузка данных из geojson файла
    func loadLandmarks() {
        guard let fileName = Bundle.main.url(forResource: "kremlin", withExtension: "geojson"),
            let landmarkData = try? Data(contentsOf: fileName) else {
                return
        }
        
        do {
            let features = try MKGeoJSONDecoder()
                .decode(landmarkData)
                .compactMap { $0 as? MKGeoJSONFeature }
            
            let validWorks = features.compactMap(Landmark.init)
            
            landmarks.append(contentsOf: validWorks)
        } catch {
            print("Unexpected error: \(error).")
        }
    }
    
}

private extension MKMapView {
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 2000) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}
