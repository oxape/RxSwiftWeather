//
//  OXPThinkpageCityModel.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/3/12.
//  Copyright © 2017年 oxape. All rights reserved.
//

import Foundation
import RealmSwift
import RxDataSources

class OXPThinkpageCityModel: Object {
    dynamic var cityID = ""
    dynamic var zhName = "未知"
    dynamic var enName = "unkonw"
    dynamic var country = ""
    dynamic var zhArea = ""
    dynamic var enArea = ""
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}

//满足RxDataSources的要求
extension OXPThinkpageCityModel: IdentifiableType{
    var identity:String {
        get {
            return cityID
        }
    }
}

extension OXPThinkpageCityModel {
    public static func ==(lhs: OXPThinkpageCityModel, rhs: OXPThinkpageCityModel) -> Bool {
        return lhs.cityID == rhs.cityID
    }
}
