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
    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.mapWindow.map.move(
            with: YMKCameraPosition.init(target: YMKPoint(latitude: 55.751574, longitude: 37.573856), zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    }
 

}

