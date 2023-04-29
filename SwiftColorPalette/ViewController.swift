//
//  ViewController.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

class ViewController: UIViewController {
    
    let colorData = ColorData()
    let colorAdjustment = ColorAdjustmentPopup(title: "Color Palette",
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
            colorAdjustment.observe(\.color, options: [.new]) { [unowned self] _, change in
                guard let newColor = change.newValue else { return }
                let index = colorPalette.currentIndex
                
                colorData.colorArray[index] = newColor
                colorPalette.refreshView(with: newColor, at: index)
                
                resultColorView.backgroundColor = newColor
            }
        )
        
        // When the remove / duplicate button is pressed.
        colorAdjustment.removeButton.addAction(.init { [unowned self] _ in
            if colorPalette.canRemoveElem {
                
                let index = colorPalette.currentIndex
                
                colorData.removeColorData(at: index)
                colorPalette.removeElem(at: index)
                
                if colorPalette.currentIndex > colorPalette.elemNum - 1 {
                    colorPalette.setArrayCountToCurrentIndex()
                    colorAdjustment.setArrowX(targetView: colorPalette.currentView, parentViewController: self)
                }
                
                let newColor = colorData.colorArray[colorPalette.currentIndex]
                colorAdjustment.refreshView(with: newColor)
                resultColorView.backgroundColor = newColor
                    
            } else {
                showToast("It cannot be removed any more")
            }
            
        }, for: .touchUpInside)
        
        colorAdjustment.duplicateButton.addAction(.init { [unowned self] _ in
            if colorPalette.canDuplicateElem {
                
                let index = colorPalette.currentIndex
                let color = colorData.colorArray[index]
                
                colorData.insert(colorData: color, at: index + 1)
                colorPalette.insert(elem: color, at: index + 1)
                
            } else {
                showToast("It cannot be added any more")
            }
            
        }, for: .touchUpInside)
    }
    private func addColorPaletteObservers() {
        
        // When the color is selected.
        observers.append(
            colorPalette.observe(\.currentIndex, options: [.old, .new]) { [unowned self] _, change in
                
                colorAdjustment.refreshView(with: colorData.colorArray[colorPalette.currentIndex])
                
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
            colorPalette.observe(\.scrollContentOffset) { [unowned self] _, _ in
                
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
        
        resultColorView.backgroundColor = colorData.colorArray[colorPalette.currentIndex]
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
