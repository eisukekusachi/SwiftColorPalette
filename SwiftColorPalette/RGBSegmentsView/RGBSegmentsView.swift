//
//  RGBSegmentsView.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

class RGBSegmentsView: UIView {
    
    weak var colorAdjustmentDelegate: ColorAdjustmentDelegate?
    
    var segmentViewCount: Int {
        return segmentedViews.count
    }
    
    private let segmentedControl = UISegmentedControl()
    private let segmentedViewContainer = UIView()
    private var segmentedViews: [ColorAdjustmentSegmentViewProtocol] = []
    
    deinit {
        print("deinit ColorAdjustmentsSegmentedControlView")
    }
    init(segmentViews: [ColorAdjustmentSegmentViewProtocol], delegate: ColorAdjustmentDelegate? = nil) {
        super.init(frame: .zero)
        colorAdjustmentDelegate = delegate
        commonInit()
        
        append(segmentViews: segmentViews)
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
        
        addSubview(segmentedControl)
        addSubview(segmentedViewContainer)
    }
    private func addConstraints() {
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            segmentedControl.leftAnchor.constraint(equalTo: leftAnchor),
            segmentedControl.rightAnchor.constraint(equalTo: rightAnchor),
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedViewContainer.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16),
            
            segmentedViewContainer.leftAnchor.constraint(equalTo: leftAnchor),
            segmentedViewContainer.rightAnchor.constraint(equalTo: rightAnchor),
            segmentedViewContainer.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    private func addParameters() {
        
        segmentedControl.setContentHuggingPriority(UILayoutPriority(1000), for: .vertical)
        segmentedControl.setContentHuggingPriority(UILayoutPriority(1000), for: .horizontal)
        segmentedControl.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        segmentedControl.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        segmentedControl.addTarget(self, action: #selector(didChangeCurrentIndex(_:)), for: .valueChanged)
    }
    @objc private func didChangeCurrentIndex(_ sender: UISegmentedControl) {
        showSegmentView(at: segmentedControl.selectedSegmentIndex)
    }
    
    // MARK: Methods
    func append(segmentViews: [ColorAdjustmentSegmentViewProtocol]) {
        segmentedViews.append(contentsOf: segmentViews)
        
        updateAllSegmentedViews()
        showSegmentView(at: segmentedControl.selectedSegmentIndex)
    }
    func refreshAllViews(with color: UIColor) {
        segmentedViews.forEach { $0.refreshView(with: color) }
    }
    
    // MARK: Private methods
    private func updateAllSegmentedViews() {
        
        // Remove all once.
        segmentedControl.removeAllSegments()
        segmentedViewContainer.subviews.forEach { $0.removeFromSuperview() }
        
        // Add views.
        segmentedViews.forEach {
            
            segmentedControl.insertSegment(withTitle: $0.title, at: segmentedControl.numberOfSegments, animated: false)
            segmentedViewContainer.addSubview($0)
            
            $0.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                $0.leftAnchor.constraint(equalTo: segmentedViewContainer.leftAnchor),
                $0.rightAnchor.constraint(equalTo: segmentedViewContainer.rightAnchor),
                $0.topAnchor.constraint(equalTo: segmentedViewContainer.topAnchor),
                $0.bottomAnchor.constraint(equalTo: segmentedViewContainer.bottomAnchor)
            ])
            
            $0.colorAdjustmentDelegate = self
        }
    }
    private func showSegmentView(at index: Int) {
        
        segmentedControl.selectedSegmentIndex = min(max(0, index), segmentedViews.count - 1)
        
        for (index, elem) in segmentedViewContainer.subviews.enumerated() {
            elem.isHidden = index != segmentedControl.selectedSegmentIndex
        }
    }
}

extension RGBSegmentsView: ColorAdjustmentDelegate {
    func changeColor(_ color: UIColor) {
        self.colorAdjustmentDelegate?.changeColor(color)
    }
}
