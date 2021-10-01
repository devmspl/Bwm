//
//  SelectorButtonView.swift
//  BWM
//
//  Created by Serhii on 10/28/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit

protocol SelectorButtonViewDelegate: class {
    func didTapButton(onView view: SelectorButtonView)
}

class SelectorButtonView: UIView {
    
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet private weak var labelText: UILabel?
    @IBOutlet private weak var buttonTap: UIButton?
    @IBOutlet private weak var viewDash: UIView?
    
    weak var delegate: SelectorButtonViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: SelectorButtonView.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewDash?.backgroundColor = .lightRed
    }
    
    func setText(_ text: String) {
        self.labelText?.text = text
    }
    
    func setSelected(_ selected: Bool) {
        viewDash?.isHidden = !selected
        labelText?.textColor = selected ? .lightRed : .lightGray
    }
    
    @IBAction private func onButtonTap() {
        delegate?.didTapButton(onView: self)
    }
}
