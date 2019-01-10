//
//  HomeController.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/22/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import UIKit
import TWMessageBarManager
import SVProgressHUD
import GooglePlaces
import CoreLocation

class HomeController: BaseViewController, CLLocationManagerDelegate {
    
    var user1 : UserModel?
    var weekWeather = [Weather]()
    var earthQuakeLocs = [Location]()
    
    var location : CLLocation?
    var locationManager = CLLocationManager()

    @IBOutlet weak var collectionV: UICollectionView!
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeZoneLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var summaryLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLocation()
        
        collectionV.delegate = self
        collectionV.dataSource = self
        
        setUpImgView()
        getUserInfo()
    }
    
    func setUpLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func setUpImgView() {
        userImgView.layer.borderWidth = 5
        userImgView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        userImgView.layer.cornerRadius = userImgView.frame.size.width / 2
        userImgView.clipsToBounds = true
    }
    
    func getUserInfo() {
    
        SVProgressHUD.show()
        FireBaseServices.shared.getUser { (user1) in
            guard let user = user1
                else {
                    SVProgressHUD.dismiss()
                    TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Couldn't retreive user information", comment: ""), type: .error, duration: 5)
                    return
            }
            
            //set all user info in UI
            DispatchQueue.main.async {
                self.userImgView.image = user.image
                self.userEmailLbl.text = user.email
            }
            
            self.getWeeklyWeather(latitude: user.latitude ?? 0, longitude: user.longitude ?? 0)
        }
    }
    
    func getWeeklyWeather(latitude : Double, longitude : Double) {
        
        SVProgressHUD.show()
            APIHandler().getWeatherInfo(latitude: latitude, longitude: longitude, completionHandler: { (weather) in
                //Set weather info in UI
                guard let weeklyWeather = weather
                    else {
                        TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Couldn't retreive Weather information", comment: ""), type: .error, duration: 5)
                        return
                    }
                
                DispatchQueue.main.async {
                    self.weekWeather = weeklyWeather
                    self.collectionV.reloadData()
                    self.dateLbl.text = weeklyWeather[0].date
                    self.tempLbl.text = "H : \(weeklyWeather[0].temperatureHigh)F / L : \(weeklyWeather[0].temperatureLow)F"
                    self.timeZoneLbl.text = weeklyWeather[0].timezone
                    self.timeLbl.text = weeklyWeather[0].time
                    self.summaryLbl.text = weeklyWeather[0].summary
                }
                SVProgressHUD.dismiss()
            })
    }
    
    func getEarthQuakeAPI() {
        SVProgressHUD.show()
        APIHandler().getEarthQuakeInfo {
            (locs) in
            guard let locations = locs
                else {
                    SVProgressHUD.dismiss()
                    TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("Couldn't retreive EarthQuake information", comment: ""), type: .error, duration: 5)
                    return
            }
            if locations.count > 0 {
                self.earthQuakeLocs = locations
                var coordinates = [[Double]]()
                for loc in locations {
                    coordinates.append(loc.coordinates)
                }
                let ctrl = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EarthQuakeController") as! EarthQuakeController
                ctrl.coordinates = coordinates
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    self.navigationController?.pushViewController(ctrl, animated: true)
                }
            } else {
                    TWMessageBarManager().showMessage(withTitle: NSLocalizedString("Error", comment: ""), description: NSLocalizedString("No data found!", comment: ""), type: .error, duration: 5)
            }
        }
    }
    
    
    @IBAction func earthQuakeBtn(_ sender: UIButton) {
        getEarthQuakeAPI()
    }
    
    @IBAction func placesBtn(_ sender: UIButton) {
        openStarLocation()
    }
    
}

extension HomeController : GMSAutocompleteViewControllerDelegate {
    
    func openStarLocation() {
        let autoCompleteCtrl = GMSAutocompleteViewController()
        autoCompleteCtrl.delegate = self
        self.locationManager.stopUpdatingLocation()
        self.present(autoCompleteCtrl, animated: true, completion: nil)
    }
    
    //Mark - GMSAutoCompleteViewControllerDelegate methods
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error : \(error)")
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let latitude : Double = place.coordinate.latitude
        let longitude : Double = place.coordinate.longitude
        getWeeklyWeather(latitude: latitude, longitude: longitude)
        self.dismiss(animated: true, completion: nil)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

extension HomeController : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekWeather.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WeatherCollCell
        cell.updateCell(highTemp: weekWeather[indexPath.row].temperatureHigh, lowTemp: weekWeather[indexPath.row].temperatureLow, timezone: weekWeather[indexPath.row].timezone, date: weekWeather[indexPath.row].date)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dateLbl.text = weekWeather[indexPath.row].date
        timeLbl.text = weekWeather[indexPath.row].time
        timeZoneLbl.text = weekWeather[indexPath.row].timezone
        tempLbl.text = "H: \(weekWeather[indexPath.row].temperatureHigh)F/ L: \(weekWeather[indexPath.row].temperatureLow)F"
    }
    
    
}



