//
//  UserLocationCell.swift
//  BWM
//
//  Created by Serhii on 10/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import Kingfisher

class UserLocationCell: UICollectionViewCell {
    
    @IBOutlet private weak var cellImage: UIImageView!
    @IBOutlet private weak var imageSelected: UIImageView!
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var viewSeparator: UIView!
    
    func updateWithAdress(_ adress: Locations) {
        labelTitle.text = adress.address
        
        if let lat = adress.latitude,
            let lon = adress.longitude {
            let url = URL(string: "https://maps.googleapis.com/maps/api/staticmap?center=\((lat)),\((lon))&zoom=17&scale=2&size=200x200&maptype=roadmap&key=AIzaSyDTSvi_smtlLvAfBggIVnEWzoTRRyGREBQ&format=png&visual_refresh=true")
            
            cellImage.kf.setImage(with: url)
        }
    }
    
    func setSelected(_ selected: Bool) {
        self.imageSelected.isHidden = !selected
    }
    
    func setShowSeparator(_ show: Bool) {
        self.viewSeparator.isHidden = !show
    }
}
