//
//  DataModel.swift
//  MapKit_2_10
//
//  Created by Лаура Есаян on 02.04.2020.
//  Copyright © 2020 LY. All rights reserved.
//

import Foundation
import MapKit

class Landmark: NSObject, MKAnnotation {
    let title: String?
    let discipline: String?
    let coordinate: CLLocationCoordinate2D
    var markerTintColor: UIColor  {
        switch discipline {
        case "Собор":
            return #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        case "Звонница":
            return #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        case "Палата":
            return #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        case "Дворец":
            return #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)
        default:
            return #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
    }
    
    init?(feature: MKGeoJSONFeature) {
        guard let point = feature.geometry.first as? MKPointAnnotation,
            let propertiesData = feature.properties,
            let json = try? JSONSerialization.jsonObject(with: propertiesData),
            let properties = json as? [String: Any] else {
                return nil
        }
        
        title = properties["title"] as? String
        discipline = properties["discipline"] as? String
        coordinate = point.coordinate
        super.init()
    }
    
    init(title: String?, discipline: String?, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.discipline = discipline
        self.coordinate = coordinate
        
        super.init()
    }
}

class LandmarkMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let landmark = newValue as? Landmark else {
                return
            }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .roundedRect)
            
            markerTintColor = landmark.markerTintColor
            if let firstLetter = landmark.discipline?.first {
                glyphText = String(firstLetter)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let title = annotation?.title {
            print(title!)
        }
    }
}

