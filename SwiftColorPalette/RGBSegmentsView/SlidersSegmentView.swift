//
//  SlidersSegmentView.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

class SlidersSegmentView: UIView, ColorAdjustmentSegmentViewProtocol {
    
    var title: String = "Sliders"
    
    weak var colorAdjustmentDelegate: ColorAdjustmentDelegate?
    
    private lazy var redSlider = ColorSliderView(title: "Red", delegate: self)
    private lazy var greenSlider = ColorSliderView(title: "Green", delegate: self)
    private lazy var blueSlider = ColorSliderView(title: "Blue", delegate: self)
    
    private let hexStringLabel = HexStringLabel()
    private let stackView = UIStackView()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        addConstraints()
        addParameters()
    }
    private func addSubviews() {
        
        addSubview(stackView)
        
        stackView.addArrangedSubview(redSlider)
        stackView.addArrangedSubview(greenSlider)
        stackView.addArrangedSubview(blueSlider)
        stackView.addArrangedSubview(hexStringLabel)
    }
    private func addConstraints() {
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    private func addParameters() {
        
        hexStringLabel.translatesAutoresizingMaskIntoConstraints = false
        hexStringLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        hexStringLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        
        let color = UIColor(red: redSlider.value,
                            green: greenSlider.value,
                            blue: blueSlider.value,
                            alpha: 255)
        
        refreshComponents(color)
    }
    
    // MARK: Methods
    func setColor(_ color: UIColor) {
        var red = CGFloat(0)
        var green = CGFloat(0)
        var blue = CGFloat(0)
        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        redSlider.setValue(Int(red * 255))
        greenSlider.setValue(Int(green * 255))
        blueSlider.setValue(Int(blue * 255))
        
        refreshComponents(color)
    }
    
    // MARK: Private methods
    private func refreshComponents(_ color: UIColor) {
        refreshRSlider(color)
        refreshGSlider(color)
        refreshBSlider(color)
        
        if let hexString = convertHexString(array: [redSlider.value, greenSlider.value, blueSlider.value]) {
            hexStringLabel.setHexString(hexString)
        }
    }
    
    private func refreshRSlider(_ color: UIColor) {
        let g: CGFloat = CGFloat(greenSlider.value) / 255.0
        let b: CGFloat = CGFloat(blueSlider.value) / 255.0
        
        let startR = UIColor(red: 0.0, green: g, blue: b, alpha: 1.0)
        let endR = UIColor(red: 1.0, green: g, blue: b, alpha: 1.0)
        redSlider.refreshView(color: color, startColor: startR, to: endR)
    }
    private func refreshGSlider(_ color: UIColor) {
        let r: CGFloat = CGFloat(redSlider.value) / 255.0
        let b: CGFloat = CGFloat(blueSlider.value) / 255.0
        
        let startG = UIColor(red: r, green: 0.0, blue: b, alpha: 1.0)
        let endG = UIColor(red: r, green: 1.0, blue: b, alpha: 1.0)
        greenSlider.refreshView(color: color, startColor: startG, to: endG)
    }
    private func refreshBSlider(_ color: UIColor) {
        let r: CGFloat = CGFloat(redSlider.value) / 255.0
        let g: CGFloat = CGFloat(greenSlider.value) / 255.0
        
        let startB = UIColor(red: r, green: g, blue: 0.0, alpha: 1.0)
        let endB = UIColor(red: r, green: g, blue: 1.0, alpha: 1.0)
        blueSlider.refreshView(color: color, startColor: startB, to: endB)
    }
    
    private func convertHexString(array: [Int]) -> String? {
        if array.count != 3 { return nil }
        return String(NSString(format: "%02X%02X%02X", array[0], array[1], array[2]))
    }
}

extension SlidersSegmentView: SliderViewDelegate {
    func changeValue(_ slider: UISlider) {
        
        let color = UIColor(red: redSlider.value,
                            green: greenSlider.value,
                            blue: blueSlider.value,
                            alpha: 255)
        refreshComponents(color)
        colorAdjustmentDelegate?.changeColor(color)
    }
}
