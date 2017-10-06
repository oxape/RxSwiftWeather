//
//  WeatherAPIService.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/2/9.
//  Copyright © 2017年 oxape. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import RxCocoa
import Moya_ObjectMapper

enum OXPWeatherAPIType {
    case ThinkpageWeatherAPI
}

class OXPWeatherAPIService {
    fileprivate let provider = RxMoyaProvider<ThinkpageWeather>()
    let apiType:OXPWeatherAPIType
    
    init(weatherAPIType: OXPWeatherAPIType) {
        apiType = weatherAPIType
    }
    
    func getWeather(cityName: String)->Observable<OXPWeatherModel> {
        return provider.request(.Weather(cityName:cityName)).filter(statusCode: 200).mapObject(OXPWeatherModel.self)
    }
}
