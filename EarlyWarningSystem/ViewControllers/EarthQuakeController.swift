//
//  EarthQuakeController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/27/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import GoogleMaps

class EarthQuakeController: BaseViewController {

    @IBOutlet weak var googleMaps: GMSMapView!
    
    var coordinates = [[Double]]()
    var name = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for coordinate in coordinates {
            createMarker(titleMarker: name, latitude: coordinate[1], longitude: coordinate[0])
        }
        let position = CLLocationCoordinate2DMake(coordinates.last![1], coordinates.last![0])
        googleMaps.camera = GMSCameraPosition.camera(withTarget: position, zoom: 10)
    }
    
    
    func createMarker(titleMarker : String, latitude : CLLocationDegrees, longitude : CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        //marker.title = titleMarker
        marker.map = googleMaps
        animateMarker(marker: marker)
    }
    
    func animateMarker(marker : GMSMarker) {
        var frames : Array<UIImage> = []
        for i in 0...44 {
            frames.append(UIImage(named: "Anim 2_\(i)")!)
        }
        marker.icon = UIImage.animatedImage(with: frames, duration: 3.0)
    }

}
