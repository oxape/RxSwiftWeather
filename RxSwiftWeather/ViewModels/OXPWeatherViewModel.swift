//
//  OXPWeatherViewModel.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/2/9.
//  Copyright © 2017年 oxape. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxSwiftUtilities

struct OXPWeatherViewModel {
    fileprivate let weatherModel: Observable<OXPWeatherModel>
    let disposeBag = DisposeBag()
    let weatherApiService = OXPWeatherAPIService(weatherAPIType:.ThinkpageWeatherAPI)
    //输出
    var cityName:Driver<String>
    var weather:Driver<String>
    var temperature:Driver<String>
    var activityIndicator:ActivityIndicator
    
    init() {
        let ac = ActivityIndicator()
        activityIndicator = ac
        weatherModel = weatherApiService.getWeather().trackActivity(ac)
//        weather = weatherApiService.getWeather().trackActivity(activityIndicator).asDriver(onErrorJustReturn: Driver<OXPWeatherModel>.empty())
        
        cityName = weatherModel.map({
            $0.cityName
        }).asDriver(onErrorJustReturn: "")
        
        weather = weatherModel.map({
            $0.text
        }).asDriver(onErrorJustReturn: "")
        
        temperature = weatherModel.map({
            String($0.temperature)
        }).asDriver(onErrorJustReturn: "")
    }
}
