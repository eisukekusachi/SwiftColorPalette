//
//  ArrayHorizontalView.swift
//  SwiftColorPalette
//
//  Created by Eisuke Kusachi on 2023/04/24.
//

import UIKit

protocol ArrayViewDelegate: AnyObject {
    func changeIndex(_ index: Int)
}

class ArrayHorizontalView<T: ArrayElemViewProtocol>: UIView, UIScrollViewDelegate {
    
    @objc private (set) dynamic var currentIndex: Int = 0 {
        didSet {
            delegate?.changeIndex(currentIndex)
        }
    }
    @objc private (set) dynamic var scrollContentOffset: CGPoint = .zero
    
    weak var delegate: (any ArrayViewDelegate)?
    
    var currentView: T? {
        guard currentIndex < arrayView.arrangedSubviews.count else { return nil }
        return (arrayView.arrangedSubviews[currentIndex] as? T)
    }
    
    var elems: [T.Elem] {
        return arrayView.arrangedSubviews.compactMap { ($0 as? T)?.elem }
    }
    
    var elemNum: Int {
        return arrayView.subviews.count
    }
    var canDuplicateElem: Bool {
        return elemNum <= maxCount - 1
    }
    var canRemoveElem: Bool {
        return elemNum > minCount
    }
    
    let defaultMinCount = 1
    let defaultMaxCount = 64
    
    private (set) var minCount: Int = 0
    private (set) var maxCount: Int = 0
    
    private let arrayView = UIStackView()
    private let scrollView = UIScrollView()
    
    
    init(_ elems: [T.Elem], delegate: ArrayViewDelegate? = nil, currentIndex: Int = 0, minCount: Int? = nil, maxCount: Int? = nil) {
        super.init(frame: .zero)
        
        self.delegate = delegate
        
        commonInit()
        reset(elems, currentIndex: currentIndex, minCount: minCount, maxCount: maxCount)
    }
    func reset(_ elems: [T.Elem], currentIndex: Int = 0, minCount: Int? = nil, maxCount: Int? = nil) {
        
        removeAll()
        append(elems: elems)
        
        setMinCount(minCount: minCount)
        setMaxCount(maxCount: maxCount)
        if self.minCount > self.maxCount {
            self.minCount = self.maxCount
        }
        
        self.currentIndex = min(currentIndex, arrayView.arrangedSubviews.count - 1)
        highlight(index: self.currentIndex)
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
        addSubview(scrollView)
        scrollView.addSubview(arrayView)
    }
    private func addConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        arrayView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: leftAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.rightAnchor.constraint(equalTo: rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            arrayView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            arrayView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            arrayView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            arrayView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            arrayView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    private func addParameters() {
        scrollView.delegate = self
        
        backgroundColor = UIColor(white: 0.75, alpha: 0.25)
        clipsToBounds = true
    }
    private func setMinCount(minCount: Int? = nil) {
        
        self.minCount = defaultMinCount
        
        if let minCount = minCount {
            self.minCount = max(1, minCount)
        }
        self.minCount = min(self.minCount, arrayView.arrangedSubviews.count)
    }
    private func setMaxCount(maxCount: Int? = nil) {
        
        self.maxCount = defaultMaxCount
        
        if let maxCount = maxCount {
            self.maxCount = max(1, maxCount)
        }
        self.maxCount = max(self.maxCount, arrayView.arrangedSubviews.count)
    }
    private func setParameters(elem: any ArrayElemViewProtocol, parentView: UIView) {
        elem.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            elem.topAnchor.constraint(equalTo: parentView.topAnchor),
            elem.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            elem.widthAnchor.constraint(equalTo: elem.heightAnchor)
        ])
        
        elem.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapView(_:))))
    }
    override func layoutSubviews() {
        if frame.size != .zero {
            layer.cornerRadius = frame.size.height * 0.5
        }
    }
    @objc private func tapView(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view,
              let index = arrayView.arrangedSubviews.firstIndex (of: view) else { return }
        
        currentIndex = index
        highlight(index: index)
    }
    
    // MARK: Methods
    func duplicate(elem: T.Elem, _ callback: ((Bool, T.Elem, Int) -> Void)? = nil) {
        if canDuplicateElem {
            
            let index = currentIndex + 1
            
            insert(elem: elem, at: index)
            callback?(true, elem, index)
            
        } else {
            callback?(false, elem, -1)
        }
    }
    func removeElem(_ callback: ((Bool, Int) -> Void)? = nil) {
        if canRemoveElem {
            
            let index = currentIndex
            
            removeElem(at: index)
            callback?(true, index)
            
            if currentIndex > arrayView.subviews.count - 1 {
                /*
                 Change the currentIndex after the callback, because when the currentIndex changes, the observer reacts.
                */
                currentIndex = arrayView.subviews.count - 1
            }
            
        } else {
            callback?(false, -1)
        }
    }
    
    func refreshView(with elem: T.Elem, _ callback: ((T.Elem, Int) -> Void)?) {
        currentView?.refreshView(with: elem)
        callback?(elem, currentIndex)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollContentOffset = scrollView.contentOffset
    }
    
    
    // MARK: Private methods
    private func highlight(index: Int) {
        for (stackViewIndex, elem) in arrayView.arrangedSubviews.enumerated() {
            (elem as? (any ArrayElemViewProtocol))?.highlight(stackViewIndex == index)
        }
    }
    private func removeAll() {
        arrayView.arrangedSubviews.reversed().forEach {
            arrayView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
    
    private func append(elems: [T.Elem?]) {
        elems.forEach {
            if let elem = $0 {
                append(elem: elem)
            }
        }
    }
    private func append(elem: T.Elem) {
        let targetView = T.self.init(elem: elem)
        arrayView.addArrangedSubview(targetView)
        setParameters(elem: targetView, parentView: arrayView)
    }
    
    private func insert(elem: T.Elem?, at index: Int) {
        guard let elem = elem else { return }
        
        currentView?.highlight(false)
        
        let targetView = T.self.init(elem: elem)
        arrayView.insertArrangedSubview(targetView, at: index)
        setParameters(elem: targetView, parentView: arrayView)
        
        currentView?.highlight(true)
    }
    private func removeElem(at index: Int) {
        currentView?.highlight(false)
        
        if let targetView = (arrayView.arrangedSubviews[index] as? T) {
            targetView.removeFromSuperview()
            arrayView.removeArrangedSubview(targetView)
        }
        
        currentView?.highlight(true)
    }
}
