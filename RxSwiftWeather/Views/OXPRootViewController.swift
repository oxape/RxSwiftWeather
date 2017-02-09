//
//  OXPRootViewController.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/2/5.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

class OXPRootViewController: OXPBaseNavViewController {

    init() {
        super.init(rootViewController: OXPHomeViewController())
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
