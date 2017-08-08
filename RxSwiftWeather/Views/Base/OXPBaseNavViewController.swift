//
//  OXPBaseNavViewController.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/2/8.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit
import FontAwesomeKit

class OXPBaseNavViewController: UINavigationController {

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0) {
            viewController.hidesBottomBarWhenPushed = true;
            let backIcon = FAKFontAwesome.chevronLeftIcon(withSize: 20)
            backIcon?.addAttribute(NSForegroundColorAttributeName, value: UIColor.white)
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: backIcon?.image(with: CGSize(width: 22, height: 22)), style: .plain, target: self, action: #selector(OXPBaseNavViewController.back))
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func back() {
        super.popViewController(animated: true)
    }
}
