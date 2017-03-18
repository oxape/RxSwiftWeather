//
//  OXPUtils.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/3/11.
//  Copyright © 2017年 oxape. All rights reserved.
//

import Foundation

class OXPUtils: NSObject {
    class func compareVersion(pversion:String, aversion:String) -> ComparisonResult? {
        let pcomponents = pversion.components(separatedBy: ".")
        let acomponents = aversion.components(separatedBy: ".")
        var i = 0
        for _ in 0...pcomponents.count-1 {
            guard let pnum = Int(pcomponents[i]) else {
                return nil
            }
            guard let anum = Int(acomponents[i]) else {
                return .orderedDescending
            }
            if pnum > anum {
                return .orderedDescending
            } else if (pnum < anum) {
                return .orderedAscending
            }
            i += 1
        }
        if pcomponents.count == acomponents.count {
            return .orderedSame
        }
        //这里pcomponents.count < acomponents.count
        return .orderedAscending
    }
}
