//
//  OXPSideMenuExtension.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/3/22.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

extension UIViewController {
    var sideMenu:OXPSideMenu? {
        var viewCtl = self
        while !viewCtl.isKind(of: OXPSideMenu.self) {
            viewCtl = viewCtl.parent!
        }
        return viewCtl as? OXPSideMenu
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
