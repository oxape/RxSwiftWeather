//
//  OXPSideMenuExtension.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/3/22.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

extension OXPSideMenu {
    var sideMenu:OXPSideMenu? {
        return nil
    }
}

extension CGFloat {
    var cfTimeInterval:CFTimeInterval {
        return CFTimeInterval(self)
    }
    var timeInterval:TimeInterval {
        return TimeInterval(self)
    }
}
