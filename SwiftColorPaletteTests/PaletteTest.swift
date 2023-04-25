//
//  PaletteTest.swift
//  SwiftColorPaletteTests
//
//  Created by Eisuke Kusachi on 2023/04/25.
//

import XCTest
@testable import SwiftColorPalette

class PaletteTest: XCTestCase {
    
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
        palette.duplicate(elem: .black)
        palette.duplicate(elem: .black) { success, _, _ in
            XCTAssertTrue(success)
        }
        palette.duplicate(elem: .black) { success, _, _ in
            XCTAssertFalse(success, "colors.count exceeds the max.")
        }
        
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
        
        palette.removeElem()
        palette.removeElem() { success, _ in
            XCTAssertTrue(success)
        }
        palette.removeElem() { success, _ in
            XCTAssertFalse(success, "colors.count exceeds the min.")
        }
        
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
