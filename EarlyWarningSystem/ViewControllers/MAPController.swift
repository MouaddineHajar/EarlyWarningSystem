//
//  MAPController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/25/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

class MAPController: UIViewController {
    
    
    @IBOutlet weak var googleMaps: GMSMapView!
    
    
    var locations = [[String:Any]]()
    var selectedMarker : GMSMarker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        googleMaps.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for loc in locations {
            showLocation(img : loc["icon"] as! UIImage, latitude: loc["latitude"] as! Double, longitude: loc["longitude"] as! Double)
        }
        let position = CLLocationCoordinate2DMake(locations.last!["latitude"] as! CLLocationDegrees, locations.last!["longitude"] as! CLLocationDegrees)
        self.googleMaps.camera = GMSCameraPosition.camera(withTarget: position, zoom: 10)
    }
    
    func showLocation(img : UIImage, latitude : Double, longitude : Double) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        
        let imgView = UIImageView(frame: CGRect(x: marker.position.latitude, y: marker.position.longitude, width: 40, height: 40))
        imgView.layer.borderWidth = 2
        imgView.layer.borderColor = UIColor.orange.cgColor
        imgView.layer.cornerRadius = imgView.frame.height/2
        imgView.layer.masksToBounds = false
        imgView.clipsToBounds = true
        imgView.image = img
        marker.iconView = imgView
        marker.map = self.googleMaps
    }
    

}

extension MAPController : GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        if let marker = selectedMarker {
            marker.iconView!.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
            marker.iconView!.layer.cornerRadius = 40/2
            marker.iconView!.layer.masksToBounds = false
            marker.iconView!.clipsToBounds = true
        }
        if let ImageView = marker.iconView as? UIImageView{
            selectedMarker = marker
            ImageView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
            ImageView.layer.cornerRadius = 80/2
            ImageView.layer.masksToBounds = false
            ImageView.clipsToBounds = true
            self.googleMaps.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 13)
            
        }
        
        return true
    }
}
