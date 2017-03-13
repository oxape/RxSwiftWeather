//
//  OXPThinkpageCityModel.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/3/12.
//  Copyright © 2017年 oxape. All rights reserved.
//

import Foundation
import RealmSwift

class OXPThinkpageCityModel: Object {
    dynamic var cityID = ""
    dynamic var zhName = ""
    dynamic var enName = ""
    dynamic var country = ""
    dynamic var zhArea = ""
    dynamic var enArea = ""
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
