//
//  ThreeButtonSelector.swift
//  BWM
//
//  Created by Serhii on 10/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit

protocol SelectorComponentViewDelegate: class {
    func selectedButtonWithIndex(_ index: Int)
}

class SelectorComponent: UIView {
    
    private var buttons: [SelectorButtonView] = []
    
    weak var delegate: SelectorComponentViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Public methods
    
    func updateWithButtons(buttonTitles: [String]) {
        self.buttons.removeAll()
        let buttonWidth = self.frame.size.width / CGFloat(buttonTitles.count)
        for title in buttonTitles {
            if let index = buttonTitles.firstIndex(of: title) {
                let x = buttonWidth * CGFloat(index)
                let view = SelectorButtonView(frame: CGRect(x: x, y: 0.0, width: buttonWidth, height: self.frame.size.height))
                view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                view.delegate = self
                view.setText(title.uppercased())
                view.tag = index
                self.addSubview(view)
                self.buttons.append(view)
            }
        }
        self.updateSelection(forIndex: 0)
    }
    
    func selectButtonWithIndex(_ index: Int) {
        self.updateSelection(forIndex: index)
        delegate?.selectedButtonWithIndex(index)
    }
    
    func updateSelection(forIndex index: Int) {
        self.buttons.forEach { (view) in
            view.setSelected(view.tag == index)
        }
    }
}

extension SelectorComponent: SelectorButtonViewDelegate {
    func didTapButton(onView view: SelectorButtonView) {
        self.selectButtonWithIndex(view.tag)
    }
}
