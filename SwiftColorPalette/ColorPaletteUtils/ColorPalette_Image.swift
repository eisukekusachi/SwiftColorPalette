//
//  ColorPalette_Image.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

enum Image {
    static func checkered(imageSize: CGSize, patternSize: CGFloat, _ color0: UIColor, _ color1: UIColor) -> UIImage? {
        
        UIGraphicsBeginImageContext(imageSize)
        defer { UIGraphicsEndImageContext() }
        
        let context: CGContext? = UIGraphicsGetCurrentContext()
        
        for i in 0 ..< Int(imageSize.width / patternSize) + 1 {
            for j in 0..<Int(imageSize.height / patternSize) + 1 {
                
                context?.setFillColor(j % 2 == i % 2 ? color0.cgColor : color1.cgColor)
                context?.fill(CGRect(x: CGFloat(i) * patternSize,
                                     y: CGFloat(j) * patternSize,
                                     width: patternSize,
                                     height: patternSize))
            }
        }
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
