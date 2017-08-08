//
//  OXPRootViewController.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/2/5.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

class OXPRootViewController: OXPSideMenu {

    override init() {
        let menuViewCtl = OXPMenuViewController()
        let homeViewCtl = OXPBaseNavViewController(rootViewController: OXPHomeViewController())
        super.init()
        self.menuViewController = menuViewCtl
        self.contentViewController = homeViewCtl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
