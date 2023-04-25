//
//  ColorData.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

class ColorData {
    var colorArray: [UIColor] = [
        .red,
        .green,
        .blue,
        .yellow,
        .black,
        Converter.color((255, 0, 0, 125)),
        Converter.color((0, 255, 0, 125)),
        Converter.color((0, 0, 255, 125)),
        Converter.color((255, 255, 0, 125)),
        Converter.color((0, 0, 0, 125))
    ]
    
    func removeColorData(at index: Int) {
        guard index < colorArray.count else { return }
        colorArray.remove(at: index)
    }
    func insert(colorData color: UIColor, at index: Int) {
        colorArray.insert(color, at: index)
    }
}

enum Converter {
    static func color(_ taple: (Int, Int, Int, Int)) -> UIColor {
        
        let colorR = CGFloat(taple.0) / 255.0
        let colorG = CGFloat(taple.1) / 255.0
        let colorB = CGFloat(taple.2) / 255.0
        let colorA = CGFloat(taple.3) / 255.0
        
        return UIColor(red: colorR, green: colorG, blue: colorB, alpha: colorA)
    }
}
