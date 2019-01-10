//
//  APIHandler.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/23/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import Foundation

class APIHandler {
    
    typealias completion = ([Weather]?)->Void
    typealias completion2 = ([Location]?)->()
    
    let urlFormat1 = "https://api.darksky.net/forecast/62ae1530a99865090bbb88b6de680476/%@,%@"
    let urlFormat2 = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_day.geojson"
    
    func getWeatherInfo(latitude : Double, longitude : Double, completionHandler : @escaping completion) {
       let urlString = String(format: urlFormat1, String(describing: latitude),String(describing: longitude))
       let url = URL(string: urlString)
        
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                let weeklyWeather = APIParser().parseWeatherInfo(data: json)
                completionHandler(weeklyWeather)
            } catch {
                completionHandler(nil)
            }
        }
        
        task.resume()
    }
    
    
    
    
    func getEarthQuakeInfo(completionHandler : @escaping completion2) {
        
        let url = URL(string: urlFormat2)
        let task = URLSession.shared.dataTask(with: url ?? URL(string: "")!) {
            (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                let locations = APIParser().jsonParseData(data : json)
                completionHandler(locations)
            } catch {
                completionHandler(nil)
            }
        }        
        task.resume()
    }
}
