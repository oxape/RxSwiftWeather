//
//  UIBarButtonExtension.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/10/6.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    class func item(image: UIImage?) -> UIBarButtonItem {
        let buttonItem = UIBarButtonItem.init(customView: UIImageView(image: image))
        return buttonItem
    }
}
