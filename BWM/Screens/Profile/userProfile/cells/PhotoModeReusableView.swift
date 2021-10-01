//
//  PhotoModeReusableView.swift
//  BWM
//
//  Created by Serhii on 10/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit

enum PhotoMode: String {
    case modeGrid
    case modeList
}

protocol PhotoModeReusableViewDelegate: class {
    func didSelectMode(_ mode: PhotoMode)
}

class PhotoModeReusableView: UICollectionReusableView {

    @IBOutlet private weak var buttonGrid: UIButton!
    @IBOutlet private weak var buttonList: UIButton!
    
    weak var delegate: PhotoModeReusableViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateWithMode(_ mode: PhotoMode) {
        if mode == .modeGrid {
            buttonGrid.setImage(R.image.profile.profileGridViewHL(), for: .normal)
            buttonList.setImage(R.image.profile.profileListViewDefault(), for: .normal)
        }
        else {
            buttonGrid.setImage(R.image.profile.profileGridViewDefault(), for: .normal)
            buttonList.setImage(R.image.profile.profileListViewHL(), for: .normal)
        }
    }
    
    @IBAction func onGridButton() {
        self.updateWithMode(.modeGrid)
        delegate?.didSelectMode(.modeGrid)
    }
    
    @IBAction func onListButton() {
        self.updateWithMode(.modeList)
        delegate?.didSelectMode(.modeList)
    }
}
