//
//  Toast.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

class Toast: UIView {
    
    private let label = UILabel()
    private let imageView = UIImageView()
    
    private let colorAlpha: CGFloat = 0.75
    
    private var startDelay: Double = 0.0
    private var startDuraton: Double = 0.15
    private var duration: Double = 52.0
    private var endDelay: Double = 0.0
    private var endDuraton: Double = 0.2
    
    private var topAnchorForHidingView: NSLayoutConstraint?
    
    private var isRemoving: Bool = false
    
    deinit {
        // print("deinit Toast")
    }
    init(text: String, systemName: String?, duration: Double = 2.0) {
        super.init(frame: .zero)
        
        label.text = text
        
        if let systemName = systemName {
            imageView.image = UIImage(systemName: systemName)
        } else {
            imageView.image = UIImage(systemName: "exclamationmark.circle")?.withTintColor(.white)
        }
        
        self.duration = duration
        
        commonInit()
    }
    init(text: String, imageName: String? = nil, duration: Double = 2.0) {
        super.init(frame: .zero)
        
        label.text = text
        
        if let imageName = imageName {
            imageView.image = UIImage(named: imageName)?.withTintColor(.white)
        } else {
            imageView.image = UIImage(systemName: "exclamationmark.circle")?.withTintColor(.white)
        }
        
        self.duration = duration
        
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        addSubviews()
        addConstraints()
        addParameters()
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapView)))
    }
    private func addSubviews() {
        
        addSubview(label)
        addSubview(imageView)
    }
    private func addConstraints() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let margin: CGFloat = 18.0
        let iconSize: CGFloat = 28.0
        
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: margin),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: iconSize),
            imageView.heightAnchor.constraint(equalToConstant: iconSize),
            
            label.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin),
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: margin),
            label.rightAnchor.constraint(equalTo: rightAnchor, constant: -margin),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: iconSize)
        ])
    }
    private func addParameters() {
        
        label.font = UIFont(name: "Helvetica", size: 16.0)
        label.textColor = .label
        label.numberOfLines = 0
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        
        imageView.tintColor = .label
        
        backgroundColor = .systemBackground.withAlphaComponent(colorAlpha)
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.systemGray.withAlphaComponent(colorAlpha).cgColor
        
        alpha = 0.0
        layer.cornerRadius = 8.0
        layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        guard let parentView = getParentViewController(self)?.view else { return }

        if topAnchorForHidingView == nil {
            
            NSLayoutConstraint.activate([
                centerXAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.centerXAnchor),
                widthAnchor.constraint(equalTo: parentView.widthAnchor, multiplier: 0.8)
            ])
            
            let bottomOffset: CGFloat = -8.0
            
            let bottomConstraint = bottomAnchor.constraint(equalTo: parentView.safeAreaLayoutGuide.bottomAnchor, constant: bottomOffset)
            bottomConstraint.priority = UILayoutPriority(750)
            bottomConstraint.isActive = true
            
            topAnchorForHidingView = topAnchor.constraint(equalTo: parentView.bottomAnchor)
            topAnchorForHidingView?.priority = UILayoutPriority(999)
            topAnchorForHidingView?.isActive = true
            
            parentView.layoutIfNeeded()
            
            showTemporarily()
        }
    }
    
    @objc private func tapView() {
        removeViewWithAnimation()
    }
    
    private func showTemporarily() {
        guard let parentView = getParentViewController(self)?.view else { return }
        
        // Show the toast.
        topAnchorForHidingView?.isActive = false
        
        UIView.animate(withDuration: startDuraton, delay: startDelay, options: .curveEaseIn, animations: { [weak self] in
            self?.alpha = 1.0
            parentView.layoutIfNeeded()
        })
        
        // Hide the toast.
        DispatchQueue.main.asyncAfter(deadline: .now() + (startDuraton + startDelay + duration)) { [weak self] in
            self?.removeViewWithAnimation()
        }
    }
    private func removeViewWithAnimation() {
        guard !isRemoving, let parentView = getParentViewController(self)?.view else { return }
        isRemoving = true
        
        self.topAnchorForHidingView?.isActive = true
        
        UIView.animate(withDuration: endDuraton, delay: endDelay, options: .curveEaseOut, animations: { [weak self] in
            self?.alpha = 0.0
            parentView.layoutIfNeeded()
        },
        completion: { [weak self] _ in
            self?.removeFromSuperview()
        })
    }
    
    private func getParentViewController(_ view: UIView) -> UIViewController? {
        var parentResponder: UIResponder? = view
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }
}
