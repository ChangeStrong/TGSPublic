//
//  ColorExtension.swift
//  SwiftFrameworkDemo
//
//  Created by gleeeli on 2020/6/17.
//  Copyright © 2020 GL. All rights reserved.
//

import UIKit

public extension UIColor {
    /// hexColor
    convenience init(hex: UInt32) {
        let r: CGFloat = CGFloat((hex & 0xFF000000) >> 24) / 255.0
        let g: CGFloat = CGFloat((hex & 0x00FF0000) >> 16) / 255.0
        let b: CGFloat = CGFloat((hex & 0x0000FF00) >> 8) / 255.0
        let a: CGFloat = CGFloat(hex & 0x000000FF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    /// 创建一张纯色的图片的方法
    func toImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(self.cgColor)
        context?.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return image!;
    }
    
//    var toHexString: String {
//            var r: CGFloat = 0
//            var g: CGFloat = 0
//            var b: CGFloat = 0
//            var a: CGFloat = 0
//            
//            self.getRed(&r, green: &g, blue: &b, alpha: &a)
//            
//            return String(
//                format: "%02X%02X%02X",
//                Int(r * 0xff),
//                Int(g * 0xff),
//                Int(b * 0xff)
//            )
//        }
    
    func toHexString() -> String {
            guard let components = cgColor.components, components.count >= 3 else {
                return "000000" // 返回黑色作为默认值
            }

            let r = Int(components[0] * 255.0)
            let g = Int(components[1] * 255.0)
            let b = Int(components[2] * 255.0)

            return String(format: "%02X%02X%02X", max(0, min(r, 255)), max(0, min(g, 255)), max(0, min(b, 255)))
        }
    
    //列：FF5251
    convenience init(hexStr: String) {
        var colorHex = hexStr
        if hexStr.contains("#") {
            colorHex = hexStr.replacingOccurrences(of: "#", with: "")
        }
            let scanner = Scanner(string: colorHex)
            scanner.scanLocation = 0
            
            var rgbValue: UInt64 = 0
            
            scanner.scanHexInt64(&rgbValue)
            
            let r = (rgbValue & 0xff0000) >> 16
            let g = (rgbValue & 0xff00) >> 8
            let b = rgbValue & 0xff
            
            self.init(
                red: CGFloat(r) / 0xff,
                green: CGFloat(g) / 0xff,
                blue: CGFloat(b) / 0xff, alpha: 1
            )
        }

    //生成随机颜色
   public static func armColor()->UIColor{
        let red = CGFloat(arc4random()%256)/255.0
        let green = CGFloat(arc4random()%256)/255.0
        let blue = CGFloat(arc4random()%256)/255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
