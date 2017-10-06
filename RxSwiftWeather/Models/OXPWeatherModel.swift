//
//  OXPWeather.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/2/9.
//  Copyright © 2017年 oxape. All rights reserved.
//

import Foundation
import ObjectMapper

struct OXPWeatherModel: Mappable {
    var cityName: String!
    var text: String!
    var code: String!
    var temperature: Float!
//    let lastUpdate: NSDate 
    
    // MARK: JSON
    init() {
        cityName = ""
        text = ""
        code = ""
        temperature = 0
    }
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        print(map.JSON)
        
        cityName <- map["results.0.location.name"]
        print(cityName)
        text <- map["results.0.now.text"]
        print(text)
        
        code <- map["results.0.now.code"]
        
        var temperatureText:String!
        temperatureText <- map["results.0.now.temperature"]
        if temperatureText != nil {
            temperature = Float(temperatureText)!+0.5
        }
    }
}
