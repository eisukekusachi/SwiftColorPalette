//
//  ColorElemView.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

class ColorElemView: UIView, ArrayElemViewProtocol {
    typealias Elem = UIColor
    
    var elem: Elem?
    
    private let backgroundImageView = UIImageView()
    private let colorView = UIView()
    private let selectedImageView = UIImageView()
    
    private let margin: CGFloat = 5.0
    
    deinit {
        // print("deinit ColorPaletteView")
    }
    required init(elem: Elem) {
        self.elem = elem
        
        super.init(frame: .zero)
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
        
        addSubview(backgroundImageView)
        addSubview(colorView)
        addSubview(selectedImageView)
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        colorView.translatesAutoresizingMaskIntoConstraints = false
        selectedImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -margin * 2.0),
            backgroundImageView.heightAnchor.constraint(equalTo: backgroundImageView.widthAnchor),
            
            colorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorView.widthAnchor.constraint(equalTo: widthAnchor, constant: -margin * 2.0),
            colorView.heightAnchor.constraint(equalTo: colorView.widthAnchor),
            
            selectedImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            selectedImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectedImageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -margin * 2.0),
            selectedImageView.heightAnchor.constraint(equalTo: selectedImageView.widthAnchor)
        ])
        
        backgroundImageView.isUserInteractionEnabled = false
        backgroundImageView.clipsToBounds = true
        
        colorView.isUserInteractionEnabled = false
        colorView.clipsToBounds = true
        colorView.backgroundColor = .clear
        
        selectedImageView.isUserInteractionEnabled = false
        selectedImageView.contentMode = .scaleAspectFill
        selectedImageView.isHidden = true
        
        if let elem = elem {
            refreshView(with: elem)
        }
    }
    
    override func layoutSubviews() {
        if frame.size != .zero {
            
            let diameter = (frame.size.width - (margin * 2))
            
            colorView.layer.cornerRadius = diameter * 0.5
            backgroundImageView.layer.cornerRadius = diameter * 0.5
            
            let image = UIImage.init(circleSize: CGSize(width: diameter, height: diameter), color: .clear)
            selectedImageView.image = drawCircles(image)
            
            let checkImage = Image.checkered(imageSize: frame.size, patternSize: 6, .white, UIColor(white: 0.92, alpha: 1.0))
            backgroundImageView.image = checkImage
        }
    }
    
    // MARK: Methods
    func refreshView(with elem: Elem) {
        colorView.backgroundColor = elem
    }
    func highlight(_ flag: Bool) {
        selectedImageView.isHidden = !flag
    }
    
    private func drawCircles(_ image: UIImage?) -> UIImage? {
        var image = image
        
        if let circleImage = image {
            let lineWidth: CGFloat = 4
            let radius = circleImage.size.width * 0.45
            
            image = image?.drawCircleCenteredAtOrigin(radius: radius - lineWidth,
                                                      lineWidth: lineWidth,
                                                      color: .black)
            
            image = image?.drawCircleCenteredAtOrigin(radius: radius - lineWidth * 0.5,
                                                      lineWidth: lineWidth,
                                                      color: .white)
        }
        
        return image
    }
}
