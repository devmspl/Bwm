//
//  PhotoPreviewController.swift
//  BWM
//
//  Created by obozhdi on 21/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoPreviewController: BaseViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewTrailingConstraint: NSLayoutConstraint!
    
    var imageUrl: String?
    var userImageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "PHOTO"
        //scrollView.maximumZoomScale = 2.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let url = URL(string: imageUrl!)
        imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.35))], progressBlock: nil) { [weak self] (image, error, _, _) in
            self?.unblockView()
            
            if error != nil,
                let urlString = self?.userImageUrl,
                let url = URL(string: urlString) {
                self?.imageView.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: { (image, error, _, _) in
                    self?.view.setNeedsLayout()
                })
            }
            else {
                self?.view.setNeedsLayout()
            }
        }
    }
    
    fileprivate func updateMinZoomScaleForSize(_ size: CGSize) {
        scrollView.maximumZoomScale = 3.0
        
        scrollView.zoomScale = 1.0
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateMinZoomScaleForSize(view.bounds.size)
    }
    
    fileprivate func updateConstraintsForSize(_ size: CGSize) {
        
        let yOffset = max(0, (size.height - imageView.frame.height) / 2)
        imageViewTopConstraint.constant = yOffset
        imageViewBottomConstraint.constant = yOffset
        
        let xOffset = max(0, (size.width - imageView.frame.width) / 2)
        imageViewLeadingConstraint.constant = xOffset
        imageViewTrailingConstraint.constant = xOffset
        
        view.layoutIfNeeded()
    }
}

extension PhotoPreviewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateConstraintsForSize(view.bounds.size)
    }
    
}
