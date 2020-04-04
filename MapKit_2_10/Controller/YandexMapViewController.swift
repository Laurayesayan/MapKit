//
//  ViewController.swift
//  MapKit_2_10
//
//  Created by Лаура Есаян on 01.04.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import UIKit
import YandexMapKit

class YandexMapViewController: UIViewController {
    @IBOutlet weak var mapView: YMKMapView!
    private var landmarks: [Landmark] = []
    private var yMarkers: [YMarker] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Attaching user location to the map.
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        
        // Reading data from .geojson.
        loadLandmarks(landmarks: &landmarks)
        for landmark in landmarks {
            let yMarker = YMarker(place: landmark)
            yMarkers.append(yMarker)
        }
        
        // Creating and attaching markers to the map.
        let mapObjects = mapView.mapWindow.map.mapObjects
        for yMarker in yMarkers {
            let placemark = mapObjects.addPlacemark(with: YMKPoint(latitude: yMarker.place.coordinate.latitude, longitude: yMarker.place.coordinate.longitude))
            placemark.opacity = 1
            placemark.setIconWith(UIImage(named:"marker")!)
            placemark.title = yMarker.title ?? "No name"
        }
        
        mapObjects.addTapListener(with: self)

        // Centering the camera around first marker.
        mapView.mapWindow.map.move(with: YMKCameraPosition.init(target: YMKPoint(latitude: yMarkers[0].place.coordinate.latitude, longitude: yMarkers[0].place.coordinate.longitude), zoom: 15, azimuth: 0, tilt: 0), animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5), cameraCallback: nil)
    }
}

extension YandexMapViewController: YMKMapObjectTapListener {
    func onMapObjectTap(with mapObject: YMKMapObject, point: YMKPoint) -> Bool {
        print(mapObject.title)
        return true
    }
}

private var AssociatedObjectTitle: UInt8 = 0
extension YMKMapObject {
    var title: String {
        get {
            return objc_getAssociatedObject(self, &AssociatedObjectTitle) as! String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedObjectTitle, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
