//
//  ViewController.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    let colorData = ColorData()
    lazy var colorPalette = ArrayHorizontalView<ColorElemView>(colorData.colorArray)
    
    var observers = [NSKeyValueObservation]()
    
    @IBOutlet weak var resultColorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addColorPalette()
        addColorObservers()
    }
    
    private func addColorPalette() {
        
        view.addSubview(colorPalette)
        colorPalette.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorPalette.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            colorPalette.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorPalette.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            colorPalette.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        resultColorView.backgroundColor = colorData.colorArray[colorPalette.currentIndex]
    }
    
    private func addColorObservers() {
        
        observers.append(
            colorPalette.observe(\.currentIndex, options: [.old, .new]) { [unowned self] _, change in
                
                let index = colorPalette.currentIndex
                
                if change.newValue != change.oldValue {
                    resultColorView.backgroundColor = colorData.colorArray[index]
                }
            }
        )
    }
}
