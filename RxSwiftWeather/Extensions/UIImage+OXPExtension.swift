//
//  OXPUIImageExtension.swift
//  RxSwiftWeather
//
//  Created by oxape on 2017/2/28.
//  Copyright © 2017年 oxape. All rights reserved.
//

import UIKit
import GPUImage


extension UIImage {
    func averageColorInRect(_ rect:CGRect) -> UIColor {
        let imageRef:CGImage
        if let cgImage = self.cgImage {
            imageRef  = cgImage
        } else {
            let context = CIContext(options: nil)
            // 创建输出
            imageRef = context.createCGImage(self.ciImage!, from: self.ciImage!.extent)!;
        }
        let width = imageRef.width
        let height = imageRef.height
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8
        let rawData = calloc(height * width * 4, MemoryLayout<CUnsignedChar>.size)!
        let context = CGContext.init(data: rawData, width: width, height: height, bitsPerComponent: bitsPerComponent, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        context.draw(imageRef, in: CGRect(x:0, y:0, width:CGFloat(width), height:CGFloat(height)))
        
        let startIndex = (Int(rect.minY) * bytesPerRow) + (Int(rect.minX) * bytesPerPixel)
        let bytesPerRowInRect = bytesPerPixel * Int(rect.width)
        var redSum:Int64 = 0;
        var greenSum:Int64 = 0;
        var blueSum:Int64 = 0;
        for row in 0..<Int(rect.height) {
            for column in 0..<Int(rect.width) {
                let index = startIndex+row * bytesPerRowInRect + column * bytesPerPixel
                let red = Int64(rawData.load(fromByteOffset: index, as: CUnsignedChar.self))
                let green = Int64(rawData.load(fromByteOffset: index+1, as: CUnsignedChar.self))
                let blue = Int64(rawData.load(fromByteOffset: index+2, as: CUnsignedChar.self))
//                print("column = \(column) red = \(red) green = \(green) blue = \(blue)")
                redSum = red + redSum
                greenSum = green + greenSum
                blueSum = blue + blueSum
            }
        }
        let doubleRed = CGFloat(redSum)/CGFloat(Int(rect.width)*Int(rect.height))/255
        let doubleGreen = CGFloat(greenSum)/CGFloat(Int(rect.width)*Int(rect.height))/255
        let doubleBlue = CGFloat(blueSum)/CGFloat(Int(rect.width)*Int(rect.height))/255
        free(rawData)
        return UIColor(red: doubleRed, green: doubleGreen, blue: doubleBlue, alpha: 1.0)
    }
    
    func scaledImageInSize(_ size:CGSize)->UIImage {
        UIGraphicsBeginImageContext(size)
        self.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let scaledImage =  UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    func blurImage(radius: Float) -> UIImage? {
        let image = CIImage(image: self)
        //创建CIFilter
        let gaussianBlur = CIFilter(name:"CIGaussianBlur")
        //设置滤镜输入参数
        gaussianBlur?.setValue(image, forKey: kCIInputImageKey)
        //设置模糊参数
        gaussianBlur?.setValue(NSNumber(value:radius), forKey: kCIInputRadiusKey)
        
        //得到处理后的图片
        if let resultImage = gaussianBlur?.outputImage {
            return UIImage(ciImage: resultImage)
        }
        return nil
    }
    
    func maskedVariableBlur(radius: Float) -> UIImage? {
        let blurFilter = GPUImageGaussianBlurPositionFilter();
        blurFilter.blurRadius = 10;
        blurFilter.blurSize = 0.1
        let blurredImage = blurFilter.image(byFilteringImage: self)
        
        return blurredImage;
    }
}
