//
//  CIFilter+OXPExtension.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/3/1.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit

extension CIFilter {
    func printBlurFilterNames() {
        let array = CIFilter.filterNames(inCategory: kCICategoryBlur)
        var localizedNames:[String] = []
        for name in array {
            localizedNames.append(CIFilter.localizedName(forFilterName: name)!)
            print(name)
            print(CIFilter(name: name)?.attributes)
        }
        print(localizedNames)
    }
}
