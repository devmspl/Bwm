//
//  UserPhotoCell.swift
//  BWM
//
//  Created by Serhii on 10/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Kingfisher
import UIKit

class UserPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImage: UIImageView?
    @IBOutlet weak var labelLikes: UILabel?
    @IBOutlet weak var labelComments: UILabel?
    @IBOutlet weak var labelDescription: UILabel?
    
    @IBOutlet weak var imageVideoIcon: UIImageView?
    @IBOutlet weak var viewData: UIView?
    
    func updateWithPhoto(_ photo: AlienPhotos, isList: Bool, completionHandler: (()->Void)? = nil) {
        if let urlString = isList ? photo.pictureUrl : photo.picturePreviewUrl,
            let url = URL(string: urlString) {
            imageVideoIcon?.isHidden = photo.videoUrl == nil
            cellImage?.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: {[weak self,completionHandler] (image, _, _, _) in
                self?.viewData?.isHidden = false
                self?.labelDescription?.isHidden = false
                if let handler = completionHandler {
                    handler()
                }
            })
        }
        
        labelLikes?.text = "\(photo.likeCount ?? 0)"
        labelComments?.text = "\(photo.commentCount ?? 0)"
        labelDescription?.text = photo.body
    }
}
