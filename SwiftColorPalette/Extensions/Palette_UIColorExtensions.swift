//
//  ColorPalette_UIColorExtensions.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

extension UIColor {
    var nAlpha: CGFloat {
        
        var alpha = CGFloat(0)
        getRed(nil, green: nil, blue: nil, alpha: &alpha)
        
        return alpha
    }
    
    convenience init(color: UIColor, alpha: Int) {
        
        var red = CGFloat(0)
        var green = CGFloat(0)
        var blue = CGFloat(0)
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        self.init(red: red,
                  green: green,
                  blue: blue,
                  alpha: CGFloat(min(max(0, alpha), 255)) / 255.0)
    }
    convenience init(red: Int, green: Int, blue: Int, alpha: Int) {
        
        self.init(red: CGFloat(min(max(0, red), 255)) / 255.0,
                  green: CGFloat(min(max(0, green), 255)) / 255.0,
                  blue: CGFloat(min(max(0, blue), 255)) / 255.0,
                  alpha: CGFloat(min(max(0, alpha), 255)) / 255.0)
    }
}
