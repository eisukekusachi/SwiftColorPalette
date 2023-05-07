//
//  HexStringLabel.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

let defaultFontFamily = "Helvetica"
let defaultBoldFontFamily = "Helvetica-Bold"
let componentsFontSize = 14.0

class HexStringLabel: UIView {
    
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    deinit {
        print("deinit HexColorLabel")
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
        addSubview(titleLabel)
        addSubview(valueLabel)
    }
    private func addConstraints() {
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            valueLabel.leftAnchor.constraint(equalTo: titleLabel.rightAnchor),
            valueLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            valueLabel.rightAnchor.constraint(equalTo: rightAnchor)
        ])
    }
    private func addParameters() {
        
        titleLabel.isUserInteractionEnabled = false
        titleLabel.font = UIFont(name: defaultFontFamily, size: componentsFontSize)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        titleLabel.text = "Hex Color # "
        titleLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        
        valueLabel.isUserInteractionEnabled = false
        valueLabel.font = UIFont(name: defaultFontFamily, size: componentsFontSize)
        valueLabel.textAlignment = .right
        valueLabel.text = "FFFFFF"
        valueLabel.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        valueLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
    }
    
    func setHexString(_ value: String) {
        valueLabel.text = value
    }
}
