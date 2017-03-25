//
//  OXPTableVersionModel.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/3/12.
//  Copyright © 2017年 oxape. All rights reserved.
//

import Foundation
import RealmSwift

class OXPTableVersionModel: Object {
    dynamic var version = ""
    dynamic var name = ""
    dynamic var uuid = ""
    
    override class func primaryKey() -> String {
        return "uuid";
    }
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
