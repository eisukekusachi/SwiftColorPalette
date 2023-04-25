//
//  ColorSliderView.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

protocol SliderViewDelegate: AnyObject {
    func changeValue(_ slider: UISlider)
}

class ColorSliderView: UIView {
    
    weak var delegate: SliderViewDelegate?
    
    var value: Int {
        return Int(slider.value * 255.0)
    }
    
    private let leftButton = UIButton()
    private let slider = UISlider()
    private let rightButton = UIButton()
    
    private let stackView = UIStackView()
    private let nameLabel = UILabel()
    private let valueLabel = UILabel()
    
    private let backgroundImage = UIImageView()
    private let gradientLayer = CAGradientLayer()
    
    deinit {
        print("deinit ColorSliderView")
    }
    
    init(title: String, delegate: SliderViewDelegate) {
        super.init(frame: .zero)
        commonInit()
        
        self.nameLabel.text = title
        self.delegate = delegate
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
        addSubview(backgroundImage)
        addSubview(slider)
        addSubview(leftButton)
        addSubview(stackView)
        addSubview(rightButton)
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(valueLabel)
    }
    private func addConstraints() {
        
        let defaultButtonSize: CGFloat = 44.0
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            leftButton.topAnchor.constraint(equalTo: slider.bottomAnchor),
            leftButton.leftAnchor.constraint(equalTo: slider.leftAnchor),
            leftButton.widthAnchor.constraint(equalToConstant: defaultButtonSize),
            leftButton.heightAnchor.constraint(equalTo: leftButton.widthAnchor),
            leftButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            slider.topAnchor.constraint(equalTo: topAnchor),
            slider.leftAnchor.constraint(equalTo: leftAnchor),
            slider.rightAnchor.constraint(equalTo: rightAnchor),
            
            rightButton.rightAnchor.constraint(equalTo: slider.rightAnchor),
            rightButton.topAnchor.constraint(equalTo: slider.bottomAnchor),
            rightButton.widthAnchor.constraint(equalToConstant: defaultButtonSize),
            rightButton.heightAnchor.constraint(equalTo: rightButton.widthAnchor),
            
            stackView.leftAnchor.constraint(equalTo: leftButton.rightAnchor),
            stackView.rightAnchor.constraint(equalTo: rightButton.leftAnchor),
            stackView.topAnchor.constraint(equalTo: leftButton.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: leftButton.bottomAnchor),
            
            nameLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            
            backgroundImage.leftAnchor.constraint(equalTo: slider.leftAnchor),
            backgroundImage.topAnchor.constraint(equalTo: slider.topAnchor),
            backgroundImage.rightAnchor.constraint(equalTo: slider.rightAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: slider.bottomAnchor)
        ])
    }
    private func addParameters() {
        
        leftButton.addAction(UIAction { [unowned self] _ in
            
            setValue(max(0, Int(slider.value * 255.0) - 1))
            delegate?.changeValue(slider)
            
        }, for: .touchUpInside)
        
        slider.addAction(UIAction { [unowned self] _ in
            
            valueLabel.text = "\(Int(slider.value * 255.0))"
            delegate?.changeValue(slider)
            
        }, for: .valueChanged)
        
        rightButton.addAction(UIAction { [unowned self] _ in
            
            setValue(min(Int(slider.value * 255.0) + 1, 255))
            delegate?.changeValue(slider)
            
        }, for: .touchUpInside)
        
        
        leftButton.setImage(UIImage(systemName: "minus.circle"), for: .normal)
        leftButton.contentMode = .scaleAspectFit
        leftButton.tintColor = .label
        leftButton.setContentHuggingPriority(UILayoutPriority.init(rawValue: 1000), for: .vertical)
        leftButton.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 1000), for: .vertical)
            
        slider.setContentHuggingPriority(UILayoutPriority.init(rawValue: 1000), for: .vertical)
        slider.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 1000), for: .vertical)
        slider.maximumTrackTintColor = .clear
        slider.minimumTrackTintColor = .clear
        
        rightButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        rightButton.contentMode = .scaleAspectFit
        rightButton.tintColor = .label
        rightButton.setContentHuggingPriority(UILayoutPriority.init(rawValue: 1000), for: .vertical)
        rightButton.setContentCompressionResistancePriority(UILayoutPriority.init(rawValue: 1000), for: .vertical)
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont(name: defaultFontFamily, size: componentsFontSize)
        nameLabel.textColor = .systemGray
        nameLabel.textAlignment = .center
        
        valueLabel.font = UIFont(name: defaultFontFamily, size: componentsFontSize)
        valueLabel.textColor = .label
        valueLabel.textAlignment = .center
        
        backgroundImage.clipsToBounds = true
    }
    override func layoutSubviews() {
        if frame.size != .zero {
            layoutIfNeeded()
            
            if let sublayers = slider.layer.sublayers, sublayers.count == 1 {
                backgroundImage.layer.insertSublayer(gradientLayer, at: 0)
            }
            
            gradientLayer.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: backgroundImage.frame.height)
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
            gradientLayer.cornerRadius = slider.frame.height * 0.5
            
            let image = Image.checkered(imageSize: CGSize(width: frame.size.width,
                                                          height: slider.frame.height),
                                        patternSize: 8, .white, UIColor(white: 0.92, alpha: 1.0))
            
            backgroundImage.image = image
            backgroundImage.layer.cornerRadius = slider.frame.size.height * 0.5
        }
    }
    
    // MARK: Methods
    func setValue(_ value: Int) {
        slider.value = Float(value) / 255.0
        valueLabel.text = "\(value)"
    }
    func refreshView(color: UIColor, startColor: UIColor, to endColor: UIColor) {
        setGradientColor(startColor, to: endColor)
        setThumbImage(color)
    }
    
    // MARK: Private methods
    private func setGradientColor(_ startColor: UIColor, to endColor: UIColor) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        CATransaction.commit()
    }
    private func setThumbImage(_ color: UIColor) {
        let multipliedValue = 1.0 / UIScreen.main.scale
        let size = slider.thumbBounds.size.width
        
        let lineWith: CGFloat = 1.0
        let radius = size * 0.5
        
        var image = UIImage(circleSize: CGSize(width: size * multipliedValue,
                                               height: size * multipliedValue),
                            color: color)
        
        image = image?.drawCircleCenteredAtOrigin(radius: radius - lineWith,
                                                  lineWidth: lineWith,
                                                  color: .black)
        
        image = image?.drawCircleCenteredAtOrigin(radius: radius - lineWith * 0.5,
                                                  lineWidth: lineWith,
                                                  color: .white)
        
        slider.setThumbImage(image, for: .normal)
    }
}

private extension UISlider {
    var trackFrame: CGRect {
        guard let superView = superview else { return CGRect.zero }
        return self.convert(trackRect(forBounds: bounds), to: superView)
    }
    var thumbBounds: CGRect {
        return thumbRect(forBounds: frame, trackRect: trackRect(forBounds: bounds), value: value)
    }
    var thumbFrame: CGRect {
        return thumbRect(forBounds: bounds, trackRect: trackFrame, value: value)
    }
}
