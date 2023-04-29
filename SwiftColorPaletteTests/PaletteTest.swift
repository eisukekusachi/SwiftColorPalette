//
//  PaletteTest.swift
//  SwiftColorPaletteTests
//
//  Created by Eisuke Kusachi on 2023/04/25.
//

import XCTest
@testable import SwiftColorPalette

class PaletteTest: XCTestCase {
    
    func duplicate(palette: ArrayHorizontalView<ColorElemView>, color: UIColor) -> Bool {
        if palette.canDuplicateElem {
            
            let index = palette.currentIndex
            palette.insert(elem: color, at: index + 1)
            
            return true
        }
        return false
    }
    func remove(palette: ArrayHorizontalView<ColorElemView>) -> Bool {
        if palette.canRemoveElem {
            
            let index = palette.currentIndex
            palette.removeElem(at: index)
            
            return true
        }
        return false
    }
    
    func testAddingColorsInPalette() {
        
        let colors: [UIColor] = [
            .black
        ]
        let resultColors: [UIColor] = [
            .black,
            .black,
            .black
        ]
        
        let maxCount = 3
        let palette = ArrayHorizontalView<ColorElemView>(colors, maxCount: maxCount)
        XCTAssertTrue(duplicate(palette: palette, color: .black))
        XCTAssertTrue(duplicate(palette: palette, color: .black))
        XCTAssertFalse(duplicate(palette: palette, color: .black))
        
        XCTAssertEqual(palette.elems, resultColors)
    }
    
    func testRemovingColorsInPalette() {
        
        let colors: [UIColor] = [
            .red,
            .green,
            .blue,
            .yellow
        ]
        let resultColors: [UIColor] = [
            .blue,
            .yellow
        ]
        
        let minCount = 2
        let palette = ArrayHorizontalView<ColorElemView>(colors, minCount: minCount)
        XCTAssertTrue(remove(palette: palette))
        XCTAssertTrue(remove(palette: palette))
        XCTAssertFalse(remove(palette: palette))
        
        XCTAssertEqual(palette.elems, resultColors)
    }
    
    func testMinMaxValuesOnPalette() {
        
        let colors: [UIColor] = [
            .black,
            .black,
            .black,
            .black,
            .black
            ]
        
        XCTContext.runActivity(named: "A normal scenario") { _ in
            
            let palette = ArrayHorizontalView<ColorElemView>(colors)
            
            XCTAssertEqual(palette.minCount, palette.defaultMinCount)
            XCTAssertEqual(palette.maxCount, palette.defaultMaxCount)
            
            
            palette.reset(colors, minCount: 2, maxCount: 15)
            XCTAssertEqual(palette.minCount, 2)
            XCTAssertEqual(palette.maxCount, 15,
                           "The min/max value can be set.")
            
            palette.reset(colors, minCount: 0)
            XCTAssertEqual(palette.minCount, 1,
                           "The minCount is greater than or equal to 1.")
        }
        
        XCTContext.runActivity(named: "The color array is stronger than the palette") { _ in
            
            let palette = ArrayHorizontalView<ColorElemView>(colors, minCount: 10)
            XCTAssertEqual(palette.minCount, 5,
                           "If the colors.count is less than the minCount, the colors.count is set to the minCount.")
            
            palette.reset(colors, maxCount: 1)
            XCTAssertEqual(palette.maxCount, 5,
                           "If the colors.count is greater than the maxCount, the colors.count set to the maxCount.")
        }
    }
}
