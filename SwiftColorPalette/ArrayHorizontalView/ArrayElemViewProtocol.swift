//
//  ArrayElemViewProtocol.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

protocol ArrayElemViewProtocol: UIView {
    associatedtype Elem
    
    init(elem: Elem)
    
    func refreshView(with elem: Elem)
    func highlight(_ flag: Bool)
}
