//
//  DetailsViewController.swift
//  Semaine2
//
//  Created by etudiant on 24/09/2018.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON

class DetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let j = JSON(UserDefaults.standard.array(forKey: "records")![Helper.shared.selectedItem])
        //let j = JSON(Helper.shared.records[Helper.shared.selectedItem])
        let coords = j["fields"]["geo_shape"]["coordinates"][0].arrayValue
        let camera = GMSCameraPosition.camera(withLatitude: Double(coords[0][1].stringValue)!, longitude: Double(coords[0][0].stringValue)!, zoom: 14.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        do {
            // Set the map style by passing the URL of the local file.
            if let styleURL = Bundle.main.url(forResource: "style", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                
            } else {
                NSLog("Unable to find style.json")
            }
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        } 	
        self.view = mapView
        
        /*// Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
        marker.title = "Sydney"
        marker.snippet = "Australia"
        marker.map = mapView
        */
        
        // Create a rectangular path
        let rect = GMSMutablePath()
        for coord in coords{
            rect.add(CLLocationCoordinate2D(latitude: Double(coord[1].stringValue)!, longitude: Double(coord[0].stringValue)!))
        }
        
        // Create the polygon, and assign it to the map.
        let polygon = GMSPolygon(path: rect)
        polygon.fillColor = UIColor(red: 0.25, green: 0, blue: 0, alpha: 0.5);
        polygon.strokeColor = .black
        polygon.strokeWidth = 2
        polygon.map = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
