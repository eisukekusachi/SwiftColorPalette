//
//  GridSegmentView.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

class GridSegmentView: UIView, ColorAdjustmentSegmentViewProtocol {
    
    var title: String = "Grid"
    
    weak var colorAdjustmentDelegate: ColorAdjustmentDelegate?
    
    private var imageView = UIImageView()
    
    init() {
        super.init(frame: .zero)
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: leftAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        let imagePath = Bundle.main.path(forResource: "grid_image_for_color_adjustment", ofType: "png")
        imageView.image = UIImage(contentsOfFile: imagePath!)
        
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapGesture)))
        imageView.addGestureRecognizer(UIPanGestureRecognizer.init(target: self, action: #selector(panGesture)))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapGesture(_ sender: UITapGestureRecognizer) {
        if let color = imageView.getColor(location: sender.location(in: self)) {
            colorAdjustmentDelegate?.changeColor(color)
        }
    }
    @objc func panGesture(_ sender: UIPanGestureRecognizer) {
        guard sender.state == .began || sender.state == .changed else { return }
        
        if let color = imageView.getColor(location: sender.location(in: self)) {
            colorAdjustmentDelegate?.changeColor(color)
        }
    }
    
    func refreshView(with color: UIColor) {}
}
