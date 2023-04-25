//
//  ColorPalette_UIImageExtensions.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

extension UIImage {
    convenience init?(circleSize: CGSize, color: UIColor = .clear) {
        
        UIGraphicsBeginImageContextWithOptions(circleSize, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        color.setFill()
        UIBezierPath(ovalIn: CGRect(x: 0.0,
                                    y: 0.0,
                                    width: circleSize.width,
                                    height: circleSize.height)).fill()
        
        if let cgImage = UIGraphicsGetImageFromCurrentImageContext()?.cgImage {
            self.init(cgImage: cgImage)
            
        } else {
            return nil
        }
    }
    
    func drawCircleCenteredAtOrigin(radius: CGFloat, lineWidth: CGFloat, color: UIColor?) -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        defer { UIGraphicsEndImageContext() }
        
        draw(in: CGRect(origin: .zero, size: size))
        
        color?.setStroke()
        UIColor.clear.setFill()
        
        let circleX: CGFloat = size.width * 0.5 - radius
        let circleY: CGFloat = size.height * 0.5 - radius
        let circleWidth: CGFloat = radius * 2.0
        let circleHeight: CGFloat = radius * 2.0
        
        let path: UIBezierPath = UIBezierPath(ovalIn: CGRect(x: circleX,
                                                             y: circleY,
                                                             width: circleWidth,
                                                             height: circleHeight))
        path.lineWidth = lineWidth
        path.stroke()
        path.fill()
        
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
