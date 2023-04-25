//
//  PopupViewWithArrow.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

class PopupViewWithArrow: UIView {
    
    let leftBarView: UIView = UIView()
    let rightBarView: UIView = UIView()
    
    let titleLabel = UILabel()
    let bodyStackView = UIStackView()
    
    var arrowCenterX: CGFloat = 0 {
        didSet {
            let offset = Paths.cornerRadius + speechBubbleArrowSize * 0.5
            arrowCenterX = max(offset, min(arrowCenterX, frame.size.width - offset))
        }
    }
    
    private let speechBubbleArrowSize: CGFloat = 15
    
    private let componentsAlpha: CGFloat = 0.96
    private let popupViewAlpha: CGFloat = 0.96
    
    private let borderAlpha: CGFloat = 0.75
    
    private let barStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        
        addSubview(barStackView)
        addSubview(bodyStackView)
        
        barStackView.addArrangedSubview(leftBarView)
        barStackView.addArrangedSubview(titleLabel)
        barStackView.addArrangedSubview(rightBarView)
        
        leftBarView.translatesAutoresizingMaskIntoConstraints = false
        barStackView.translatesAutoresizingMaskIntoConstraints = false
        rightBarView.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            leftBarView.widthAnchor.constraint(equalToConstant: 32),
            leftBarView.heightAnchor.constraint(equalTo: leftBarView.widthAnchor),
            
            rightBarView.widthAnchor.constraint(equalToConstant: 32),
            rightBarView.heightAnchor.constraint(equalTo: rightBarView.widthAnchor),
            
            
            barStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            barStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            barStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            barStackView.bottomAnchor.constraint(equalTo: bodyStackView.topAnchor, constant: -16),
            
            bodyStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            bodyStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            bodyStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24)
        ])
        
        
        barStackView.axis = .horizontal
        barStackView.distribution = .equalSpacing
        
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: defaultFontFamily, size: componentsFontSize)
        titleLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        titleLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        
        bodyStackView.axis = .vertical
        
        arrowCenterX = 0
        
        isUserInteractionEnabled = true
        backgroundColor = .clear
    }
    func setArrowX(targetView: UIView?, parentViewController: UIViewController) {
        guard let targetView = targetView else { return }
            
        arrowCenterX = self.getRelativeCenterX(target: targetView, parentView: parentViewController.view)
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let path: UIBezierPath = UIBezierPath()
        
        Paths.drawPathBubbleWithBottomArrow(path: path,
                                            lineWidth: 1.0,
                                            radius: Paths.cornerRadius,
                                            rect: rect,
                                            arrowCenterX: arrowCenterX,
                                            arrowSize: CGSize(width: speechBubbleArrowSize,
                                                              height: speechBubbleArrowSize))
        
        UIColor.systemBackground.withAlphaComponent(popupViewAlpha).setFill()
        UIColor.systemGray.withAlphaComponent(borderAlpha).setStroke()
        
        path.fill()
        path.stroke()
    }
}
