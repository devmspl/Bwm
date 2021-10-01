//
//  LocationHeaderReusableView.swift
//  BWM
//
//  Created by Serhii on 11/13/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit

protocol LocationHeaderDelegate: class {
    func didTapExpandButton()
    func didTapAddLocationButton()
}

class LocationHeaderReusableView: UICollectionReusableView {
    
    weak var delegate: LocationHeaderDelegate?
    
    @IBOutlet private weak var expandButton: UIButton!
    @IBOutlet private weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setExpanded(false)
    }
    
    func shouldShowExpandButton(_ show: Bool) {
        self.expandButton.isHidden = !show
    }
    
    func shouldShowAddButton(_ show: Bool) {
        self.addButton.isHidden = !show
    }
    
    func setExpanded(_ expanded: Bool) {
        self.expandButton.setImage(expanded ? R.image.common.arrow_up() : R.image.common.arrow_down(), for: .normal)
    }
    
    @IBAction private func onButtonExpand() {
        self.delegate?.didTapExpandButton()
    }
    
    @IBAction private func onButtonAdd() {
        self.delegate?.didTapAddLocationButton()
    }
}
