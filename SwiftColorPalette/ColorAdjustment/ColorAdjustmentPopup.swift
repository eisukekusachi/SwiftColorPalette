//
//  ColorAdjustmentPopup.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

protocol ColorAdjustmentDelegate: AnyObject {
    func changeColor(_ color: UIColor)
}
protocol ColorAdjustmentSegmentViewProtocol: UIView {
    var title: String { get }
    
    var colorAdjustmentDelegate: ColorAdjustmentDelegate? { get set }
    func setColor(_ color: UIColor)
}

class ColorAdjustmentPopup: PopupViewWithArrow {
    
    @objc private (set) dynamic var color: UIColor = .black {
        didSet {
            colorAdjustmentDelegate?.changeColor(color)
        }
    }
    weak var colorAdjustmentDelegate: ColorAdjustmentDelegate?
    
    private var storedRGBColor: UIColor = .black
    private var storedAlpha: Int = 255
    private var currentColor: UIColor {
        return UIColor.init(color: storedRGBColor, alpha: storedAlpha)
    }
    
    private var title: String = ""
    
    private var rgbSegmentsView: RGBSegmentsView!
    private var alphaSlider: ColorSliderView!
    
    private let closeButton = UIButton()
    private let buttonStackView = UIStackView()
    let removeButton = UIButton()
    let duplicateButton = UIButton()
    
    private var adjustmentViewHeight: CGFloat = 0
    
    deinit {
        print("deinit ColorAdjustmentsPopup")
    }
    init(title: String = "",
         adjustmentViewHeight: CGFloat = 320,
         segmentViews: [ColorAdjustmentSegmentViewProtocol],
         delegate: ColorAdjustmentDelegate? = nil) {
        
        self.title = title
        self.adjustmentViewHeight = adjustmentViewHeight
        self.colorAdjustmentDelegate = delegate
        
        super.init(frame: .zero)
        
        self.rgbSegmentsView = RGBSegmentsView(segmentViews: segmentViews, delegate: self)
        self.alphaSlider = ColorSliderView(title: "Alpha", delegate: self)
        
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        addSubviews()
        addConstraints()
        addParameters()
    }
    private func addSubviews() {
        
        rightBarView.addSubview(closeButton)
        
        bodyStackView.addArrangedSubview(rgbSegmentsView)
        bodyStackView.addArrangedSubview(alphaSlider)
        bodyStackView.addArrangedSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(removeButton)
        buttonStackView.addArrangedSubview(duplicateButton)
    }
    private func addConstraints() {
        
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        rgbSegmentsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            closeButton.leftAnchor.constraint(equalTo: rightBarView.leftAnchor),
            closeButton.topAnchor.constraint(equalTo: rightBarView.topAnchor),
            closeButton.rightAnchor.constraint(equalTo: rightBarView.rightAnchor),
            closeButton.bottomAnchor.constraint(equalTo: rightBarView.bottomAnchor),
            
            rgbSegmentsView.heightAnchor.constraint(equalToConstant: adjustmentViewHeight)
        ])
    }
    private func addParameters() {
        
        closeButton.setImage(UIImage(systemName: "x.circle.fill"), for: .normal)
        closeButton.tintColor = .label
        closeButton.addAction(.init { [unowned self] _ in
            removeFromSuperview()
        }, for: .touchUpInside)
        
        titleLabel.text = title
        titleLabel.textColor = .systemGray
        
        bodyStackView.setCustomSpacing(16, after: rgbSegmentsView)
        bodyStackView.setCustomSpacing(8, after: alphaSlider)
        
        removeButton.titleLabel?.font = UIFont(name: defaultBoldFontFamily, size: 15.0)
        removeButton.setTitle("Remove", for: .normal)
        removeButton.setTitleColor(.systemRed, for: .normal)
        
        duplicateButton.titleLabel?.font = UIFont(name: defaultBoldFontFamily, size: 15.0)
        duplicateButton.setTitle("Duplicate", for: .normal)
        duplicateButton.setTitleColor(.label, for: .normal)
        
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        isUserInteractionEnabled = true
    }
    
    // MARK: Methods
    func refreshView(with color: UIColor) {
        
        storedRGBColor = color
        storedAlpha = Int(color.alpha * 255)
        
        let newColor = currentColor
        
        rgbSegmentsView.refreshAllViews(with: newColor)
        refreshAlphaSliderView(alphaValue: storedAlpha, newColor)
        
        self.color = newColor
    }
    
    // MARK: Private methods
    private func refreshAlphaSliderView(alphaValue: Int, _ color: UIColor) {
        
        alphaSlider.setValue(alphaValue)
        
        let startA = UIColor(color: color, alpha: 0)
        let endA = UIColor(color: color, alpha: 255)
        alphaSlider.refreshView(color: color, startColor: startA, to: endA)
    }
}

// MARK: RGB
extension ColorAdjustmentPopup: ColorAdjustmentDelegate {
    func changeColor(_ color: UIColor) {
        
        storedRGBColor = color
        
        let newColor = currentColor
        
        rgbSegmentsView.refreshAllViews(with: newColor)
        refreshAlphaSliderView(alphaValue: storedAlpha, newColor)
        
        self.color = newColor
    }
}

// MARK: Alpha
extension ColorAdjustmentPopup: SliderViewDelegate {
    func changeValue(_ slider: UISlider) {
        
        storedAlpha = Int(slider.value * 255.0)
        
        self.color = currentColor
    }
}
