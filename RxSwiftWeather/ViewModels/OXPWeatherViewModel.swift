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
    fileprivate let weatherModel: Driver<OXPWeatherModel>
    let disposeBag = DisposeBag()
    var weatherApiService:OXPWeatherAPIService;
    //输入
    fileprivate let refreshAction = PublishSubject<String>()
    //输出
    var cityName:Driver<String>
    var weather:Driver<String>
    var weatherImage:Driver<UIImage?>
    var temperature:Driver<String>
    var activityIndicator:ActivityIndicator
    
    init() {
        let ac = ActivityIndicator()
        let apiService = OXPWeatherAPIService(weatherAPIType:.ThinkpageWeatherAPI)
        activityIndicator = ac
        weatherApiService = apiService
        
        weatherModel = refreshAction.debug().flatMapLatest({
            return apiService
                .getWeather(cityName: $0)
                .trackActivity(ac)
        }).asDriver(onErrorJustReturn: OXPWeatherModel())
        
        cityName = weatherModel.map({
            $0.cityName
        })
        
        weather = weatherModel.map({
            $0.text
        })
        
        weatherImage = weatherModel.map({
            UIImage(named: "thinpageWeather"+$0.code)
        })
        
        temperature = weatherModel.map({
            String(Int($0.temperature))+"℃"
        })
    }
    
    func refresh(_ cityName:String) {
        self.refreshAction.on(.next(cityName))
    }
}
