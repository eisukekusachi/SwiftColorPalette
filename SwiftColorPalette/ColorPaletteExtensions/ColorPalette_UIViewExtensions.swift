//
//  ColorPalette_UIViewExtensions.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }
    
    func getRelativeCenterX(target: UIView, parentView: UIView) -> CGFloat {
        
        let globalSelfRect = self.convert(self.bounds, to: parentView)
        let globalTargetRect = target.convert(target.bounds, to: parentView)
        let paletteCenterX = globalTargetRect.size.width * 0.5 + globalTargetRect.origin.x
        
        return paletteCenterX - globalSelfRect.origin.x
    }
    
    func exists<T: UIView>(_ type: T.Type) -> Bool {
        
        var exists: Bool = false
    
        for view in subviews where view is T {
            exists = true
        }
        return exists
    }
    
    func remove<T: UIView>(_ type: T.Type) {
        
        for view in subviews.reversed() where view is T {
            view.removeFromSuperview()
        }
    }
}
