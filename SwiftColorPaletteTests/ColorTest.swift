//
//  ColorTest.swift
//  SwiftColorPaletteTests
//
//  Created by Eisuke Kusachi on 2023/05/07.
//

import XCTest
@testable import SwiftColorPalette

class ColorTest: XCTestCase {
    
    func testChangeColor() {
        
        var colors: [UIColor] = [.red, .green]
        
        let colorPalette = ArrayHorizontalView<ColorElemView>(colors, index: 1)
        let colorAdjustment = ColorAdjustmentPopup()
        
        colorAdjustment.didChangeColor = { newColor in
            
            colors[colorPalette.index] = newColor
            colorPalette.refreshView(with: newColor)
            
            XCTAssertEqual(colorPalette.elem, newColor)
            XCTAssertEqual(colors, [.red, .red])
        }
        colorAdjustment.refreshView(with: .red)
    }
    func testChangeIndex() {
        
        let colors: [UIColor] = [.red, .green]
        
        let colorPalette = ArrayHorizontalView<ColorElemView>(colors, index: 0)
        let colorAdjustment = ColorAdjustmentPopup()
        
        colorPalette.didChangeIndex = { oldIndex, newIndex in
            
            let newColor = colors[newIndex]
            colorAdjustment.refreshView(with: newColor)
            
            XCTAssertEqual(colors[oldIndex], .red)
            XCTAssertEqual(colors[newIndex], .green)
            
            XCTAssertEqual(colorAdjustment.color, newColor)
        }
        colorPalette.selectView(1)
    }
}
