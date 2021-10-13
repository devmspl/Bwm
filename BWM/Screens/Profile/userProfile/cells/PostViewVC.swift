//
//  PostViewVC.swift
//  BWM
//
//  Created by mac on 11/10/21.
//  Copyright © 2021 Almet Systems. All rights reserved.
//

import UIKit
import AlamofireImage

class PostViewVC: UIViewController {

    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var postImage: UIImageView!
   
    var video = ""
    var image = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: image)
        postImage.af_setImage(withURL: url!)
    }
    


}
