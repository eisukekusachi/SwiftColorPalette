//
//  ColorPalette_UIImageViewExtensions.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

extension UIImageView {
    func getColor(location: CGPoint) -> UIColor? {
        guard let image = self.image else { return nil }
        
        let imageLocation = CGPoint.init(x: location.x * (image.size.width / self.frame.width),
                                         y: location.y * (image.size.height / self.frame.height))
        
        guard   imageLocation.x >= 0.0 &&
                imageLocation.y >= 0.0 &&
                imageLocation.x < image.size.width &&
                imageLocation.y < image.size.height else {
            
            return nil
        }
        
        if let cgImage = image.cgImage,
           let dataPrivider = cgImage.dataProvider {
            
            let providerData = dataPrivider.data
            let data: UnsafePointer<UInt8> = CFDataGetBytePtr(providerData)
            let pixelInfo: Int = (Int(imageLocation.x) + Int(imageLocation.y) * Int(image.size.width)) * 4
            
            let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
            let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
            let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
            let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
            
            return UIColor(red: r, green: g, blue: b, alpha: a)
            
        } else {
            return nil
        }
    }
}
