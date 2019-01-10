//
//  APIParser.swift
//  EarlyWarningSystem
//
//  Created by Hajar Mouaddine on 12/23/18.
//  Copyright © 2018 Hajar Mouaddine. All rights reserved.
//

import Foundation

class APIParser {
    
    func parseWeatherInfo(data : [String:Any]) -> [Weather] {
        
        var weeklyWeather = [Weather]()
        
        let timezone = data["timezone"] as! String
        
        let daily = data["daily"] as! [String:Any]
        let dailyWeather = daily["data"] as! [[String:Any]]
        
        for day in dailyWeather {
            let time1 = day["time"] as! Int64
            let Ndate1 : NSDate = NSDate(timeIntervalSince1970: TimeInterval(time1))
            let dateFull1 = String(describing: Ndate1).prefix(16)
            let date1 = dateFull1.prefix(10)
            let td1 = dateFull1.suffix(6)
            let summary1 = day["summary"] as! String
            let tempHigh = day["temperatureHigh"] as! Double
            let tempLow = day["temperatureLow"] as! Double
            
            weeklyWeather.append(Weather(timezone: timezone, date: String(date1), time: String(td1), summary: summary1, temperatureHigh: tempHigh, temperatureLow: tempLow))
        }
        return weeklyWeather
    }
    
    func jsonParseData(data : [String:Any]) -> [Location]{
        var locsArr = [Location]()
        let features = data["features"] as! [[String:Any]]
        
        for feat in features {
            let properties = feat["properties"] as! [String:Any]
            let name = properties["title"] as! String
            let mag = properties["mag"] as! NSNumber
            let geometry = feat["geometry"] as! [String:Any]
            let coordinates = geometry["coordinates"] as! [Double]
            
            locsArr.append(Location(title: name, mag: Int(mag), coordinates: coordinates))
            
        }
        
        return locsArr
    }
}
