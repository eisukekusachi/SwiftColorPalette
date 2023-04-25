//
//  ArrayElemViewProtocol.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

protocol ArrayElemViewProtocol: UIView {
    associatedtype Elem
    
    var elem: Elem? { get }
    
    init(elem: Elem)
    
    func refreshView(with elem: Elem)
    func highlight(_ flag: Bool)
}
