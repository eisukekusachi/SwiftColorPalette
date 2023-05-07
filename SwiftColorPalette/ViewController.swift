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
        addObservers()
    }
    
    private func addObservers() {
        
        // If the index of the data changes, the adjustment is refreshed.
        colorPalette.didChangeIndex = { [unowned self] oldIndex, newIndex in
            if oldIndex != newIndex {
                colorData.index = newIndex
                
            } else {
                toggleColorAdjustment()
            }
        }
        observers.append(
            colorData.observe(\.index) { [unowned self] _, _ in
                
                let color = colorData.currentColor
                refreshColorAdjustment(color)
                
                resultColorView.backgroundColor = color
            }
        )
        
        // If the color of the data changes, the palette is refreshed.
        colorAdjustment.didChangeColor = { [unowned self] color in
            colorData.colorArray[colorData.index] = color
        }
        observers.append(
            colorData.observe(\.colorArray) { [unowned self] _, _ in
                guard   colorData.colorArray.count == colorPalette.elems.count &&
                        colorData.index < colorData.colorArray.count else { return }
                
                let index = colorData.index
                let color = colorData.colorArray[index]
                colorPalette.refreshView(with: color, at: index)
                
                resultColorView.backgroundColor = color
            }
        )
        
        // When the remove / duplicate button is pressed.
        colorAdjustment.didTapRemoveButton = { [unowned self] in
            if colorPalette.canRemoveElem {
                
                let index = colorPalette.index
                
                colorData.removeColorData(at: index)
                colorPalette.removeElem(at: index)
                
                if colorPalette.index > colorPalette.elemNum - 1 {
                    colorPalette.setArrayCountToCurrentIndex()
                }
                colorData.index = colorPalette.index
                
            } else {
                showToast("It cannot be removed any more")
            }
        }
        colorAdjustment.didTapDuplicateButton = { [unowned self] in
            if colorPalette.canDuplicateElem {
                
                let index = colorPalette.index
                let color = colorData.colorArray[index]
                
                colorData.insert(colorData: color, at: index + 1)
                colorPalette.insert(elem: color, at: index + 1)
                
            } else {
                showToast("It cannot be added any more")
            }
        }
        
        // When the palette is scrolled.
        colorPalette.didDragScrolView = { [unowned self] _ in
            colorAdjustment.setArrowX(targetView: colorPalette.currentView, parentViewController: self)
        }
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
        resultColorView.backgroundColor = colorData.currentColor
    }
    private func toggleColorAdjustment() {
        if !view.exists(ColorAdjustmentPopup.self) {
            
            view.addSubview(colorAdjustment)
            
            colorAdjustment.translatesAutoresizingMaskIntoConstraints = false
            
            let multiplier = UIDevice.current.userInterfaceIdiom == .phone ? 0.8 : 0.4
            NSLayoutConstraint.activate([
                colorAdjustment.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier),
                colorAdjustment.centerXAnchor.constraint(equalTo: colorPalette.centerXAnchor),
                colorAdjustment.bottomAnchor.constraint(equalTo: colorPalette.topAnchor, constant: -8)
            ])
            
            refreshColorAdjustment(colorData.currentColor)
            
        } else {
            colorAdjustment.removeFromSuperview()
        }
    }
    
    private func refreshColorAdjustment(_ color: UIColor?) {
        guard let color = color else { return }
        
        colorAdjustment.refreshView(with: color)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [unowned self] in
            colorAdjustment.setArrowX(targetView: colorPalette.currentView, parentViewController: self)
        }
    }
    private func showToast(_ text: String) {
        if !view.exists(Toast.self) {
            view.addSubview(Toast(text: text))
        }
    }
}
