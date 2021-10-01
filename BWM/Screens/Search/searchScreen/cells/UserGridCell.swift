//
//  UserGridCell.swift
//  BWM
//
//  Created by Serhii on 10/30/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import Kingfisher

class UserGridCell: UICollectionViewCell {
    @IBOutlet private weak var imageAvatar: UIImageView!
    @IBOutlet private weak var labelFollowersCount: UILabel!
    @IBOutlet private weak var imageVerified: UIImageView!
    
    @IBOutlet private weak var viewFollowers: UIView!
    
    func setData(image: String, followers: Int?, verified: Bool) {
        let url = URL(string: image)
        imageAvatar.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.35))], progressBlock: nil) { _, _, _, _ in
            self.viewFollowers.isHidden = false
        }
        let followersCount = followers ?? 0
        labelFollowersCount.text = "Followers: \(followersCount.roundedString)"
        
        if verified {
            imageVerified.image = R.image.search.badge_on()
        } else {
            imageVerified.image = R.image.search.badge_off()
        }
    }
}
