//
//  ThinkpageWeather.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/2/9.
//  Copyright © 2017年 oxape. All rights reserved.
//

import Foundation
import Moya

enum ThinkpageWeather{
    case Weather(cityName: String)
}

extension ThinkpageWeather: TargetType {
    //BaseURL
    var baseURL: URL {
        return URL(string: "https://api.thinkpage.cn/v3/weather/")!
    }
    //URL相对路径
    var path: String {
        switch self {
        case .Weather:
            return "/now.json"
        }
    }
    //动作的请求方法
    var method: Moya.Method {
        switch self {
        case .Weather:
            return .get
        }
    }
    //动作的请求参数
    var parameters: [String: Any]? {
        switch self {
        case .Weather(let cityName):
            return ["key": "kafbhmhecgg6vpjm",
                    "location": cityName,
                    "language": "zh-Hans",
                    "unit": "c"]
        }
    }
    //参数的译码
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .Weather:
            return URLEncoding.queryString
        }
    }
    
    var sampleData: Data {
        switch self {
        case .Weather:
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        return .request
    }
    
    var validate: Bool {
        return false
    }
}

