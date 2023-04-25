//
//  ViewController.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    let colorData = ColorData()
    var colorAdjustment = ColorAdjustmentPopup(title: "Color Palette",
                                               segmentViews: [
                                                GridSegmentView(),
                                                SpectrumSegmentView(),
                                                SlidersSegmentView()
                                               ])
    lazy var colorPalette = ArrayHorizontalView<ColorElemView>(colorData.colorArray)
    var observers = [NSKeyValueObservation]()
    
    @IBOutlet weak var resultColorView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addColorPalette()
        addColorPaletteObservers()
        addColorAdjustmentObservers()
    }
    
    private func addColorAdjustmentObservers() {
        
        // When the color changes.
        observers.append(
            colorAdjustment.observe(\.color, options: [.old, .new]) { [unowned self] _, change in
                guard let color = change.newValue else { return }
                
                colorPalette.refreshView(with: color) { [unowned self] newColor, index in
                    colorData.colorArray[index] = newColor
                }
                resultColorView.backgroundColor = currentPaletteColor
            }
        )
        
        // When the remove / duplicate button is pressed.
        colorAdjustment.removeButton.addAction(.init { [unowned self] _ in
            
            colorPalette.removeElem { [unowned self] success, indexToBeDeleted in
                if success {
                    colorData.removeColorData(at: indexToBeDeleted)
                    
                } else {
                    showToast("It cannot be removed any more")
                }
            }
            colorAdjustment.refreshView(with: currentPaletteColor)
            
        }, for: .touchUpInside)
        
        colorAdjustment.duplicateButton.addAction(.init { [unowned self] _ in
            
            colorPalette.duplicate(elem: currentPaletteColor) { [unowned self] success, newColor, indexToBeInserted in
                if success {
                    colorData.insert(colorData: newColor, at: indexToBeInserted)
                    
                } else {
                    showToast("It cannot be added any more")
                }
            }
            colorAdjustment.refreshView(with: currentPaletteColor)
            
        }, for: .touchUpInside)
    }
    private func addColorPaletteObservers() {
        
        // When the color is selected.
        observers.append(
            colorPalette.observe(\.currentIndex, options: [.old, .new]) { [unowned self] _, change in
                
                colorAdjustment.refreshView(with: currentPaletteColor)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned self] in
                    colorAdjustment.setArrowX(targetView: colorPalette.currentView, parentViewController: self)
                }
                
                if change.newValue == change.oldValue {
                    toggleColorAdjustment()
                }
            }
        )
        
        // When the palette is scrolled.
        observers.append(
            colorPalette.observe(\.scrollContentOffset, options: [.old, .new]) { [unowned self] _, change in
                
                colorAdjustment.setArrowX(targetView: colorPalette.currentView, parentViewController: self)
            }
        )
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
        
        resultColorView.backgroundColor = currentPaletteColor
    }
    private func addColorAdjustment() {
        
        view.addSubview(colorAdjustment)
        
        colorAdjustment.translatesAutoresizingMaskIntoConstraints = false
        
        let multiplier = UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.4
        
        NSLayoutConstraint.activate([
            colorAdjustment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier),
            colorAdjustment.centerXAnchor.constraint(equalTo: colorPalette.centerXAnchor),
            colorAdjustment.bottomAnchor.constraint(equalTo: colorPalette.topAnchor, constant: -8),
        ])
    }
}

extension ViewController {
    var currentPaletteColor: UIColor {
        return colorData.colorArray[colorPalette.currentIndex]
    }
    private func toggleColorAdjustment() {
        if !view.exists(PopupViewWithArrow.self) {
            addColorAdjustment()
            
        } else {
            view.remove(PopupViewWithArrow.self)
        }
    }
    
    private func showToast(_ text: String) {
        if !view.exists(Toast.self) {
            view.addSubview(Toast(text: text))
        }
    }
}
