//
//  UserHeaderCell.swift
//  BWM
//
//  Created by Serhii on 10/31/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import QuartzCore

class UserHeaderCell: UICollectionViewCell {
    @IBOutlet weak var imageAvatar : UIImageView!
    @IBOutlet weak var labelName : UILabel!
    @IBOutlet weak var imageVerified  : UIImageView!
    @IBOutlet weak var imageGradient: UIImageView!
    
    @IBOutlet weak var viewLive: UIView?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageAvatar.layer.borderColor = UIColor.lightGray.cgColor
        imageAvatar.layer.borderWidth = 0.0
        
        viewLive?.isHidden = true
        
        imageAvatar.layer.removeAnimation(forKey: "transform.scale")
    }
    
    func animate() {
        viewLive?.isHidden = false
        if imageAvatar.layer.animation(forKey: "transform.scale") == nil {
            let pulseAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.scale")
            pulseAnimation.duration = 1.0
            pulseAnimation.fromValue = 0.8
            pulseAnimation.toValue = NSNumber(value: 1.0)
            pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pulseAnimation.autoreverses = true
            pulseAnimation.repeatCount = Float.infinity
            CACurrentMediaTime()
            imageAvatar.layer.add(pulseAnimation, forKey: "transform.scale")
        }
    }
    
    func setData(title: String, image: String, fill: Bool, hasBadge: Bool) {
        if fill {
            let url = URL(string: image)
            imageAvatar.kf.setImage(with: url, placeholder: R.image.common.avatarPlaceholder(), options: [.transition(.fade(0.35))], progressBlock: nil, completionHandler: nil)
            imageAvatar.layer.borderColor = UIColor.lightGray.cgColor
            imageAvatar.layer.borderWidth = 1.0
            imageGradient.image = R.image.common.gradient()
        } else {
            imageGradient.image = UIImage()
            imageAvatar.image = R.image.search.fbtn()
        }
        
        labelName.text  = title
        
        if fill {
            imageAvatar.contentMode = .scaleAspectFill
        } else {
            imageAvatar.contentMode = .scaleAspectFit
        }
        if hasBadge == false {
            imageVerified.isHidden = true
        } else {
            imageVerified.isHidden = false
        }
    }
}
