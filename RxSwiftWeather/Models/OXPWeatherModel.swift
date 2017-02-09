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
    var code: Int!
    var temperature: Float!
//    let lastUpdate: NSDate 
    
    // MARK: JSON
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        cityName <- map["results.0.location.name"]
        
        text <- map["results.0.now.text"]
        
        var codeText:String!
        codeText <- map["results.0.now.code"]
        if codeText != nil {
            code = Int(codeText)
        }
        
        var temperatureText:String!
        temperatureText <- map["results.0.now.temperature"]
        if temperatureText != nil {
            temperature = Float(temperatureText)!+0.5
        }
    }
}
