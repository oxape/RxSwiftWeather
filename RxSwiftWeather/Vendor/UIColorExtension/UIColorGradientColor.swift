//
//  UIColorGradientColor.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/10/6.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit
import Foundation
import CoreGraphics

extension UIColor {
    
    func gradientColor(start: UIColor, end: UIColor, steps: Int, gamma: Double = 1) ->[UIColor] {
        let starts = getRGBComponents(color: start).map({ pow(Double($0), gamma) })
        let ends = getRGBComponents(color: end).map({ pow(Double($0), gamma) })
        var colors:[UIColor] = []
        for i in 0..<steps {
            let ms = i / (steps - 1);
            let me = 1 - ms;
            var so:[Double] = [0, 0, 0]
            for j in 0..<3 {
                so[j] = round(pow(starts[j] * Double(me) + ends[j] * Double(ms), 1 / gamma) * 255);
            }
            colors.append(UIColor(red: CGFloat(so[0]), green: CGFloat(so[1]), blue: CGFloat(so[2]), alpha: 1.0));
        }
        return colors;
    };
    
    func getRGBComponents(color: UIColor) -> [CGFloat] {
        let components = color.cgColor.components!
        return components
    }
}
