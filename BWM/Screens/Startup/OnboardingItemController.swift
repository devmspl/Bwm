//
//  OnboardingItemController.swift
//  BWM
//
//  Created by Serhii on 10/14/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit

class OnboardingItemController: UIViewController {

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var labelTitle: UILabel!
    @IBOutlet private weak var labelText: UILabel!
    
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.updateForIndex(index)
        self.view.setNeedsLayout()
    }
    
    func updateForIndex(_ index:Int) {
        
        switch index {
        case 0:
            self.imageView.image = R.image.onboarding.screen1()
            self.labelTitle.text = "INSTA-SERVICES"
            self.labelText.text = "Find and chat with local freelancers in and around your city"
        case 1:
            self.imageView.image = R.image.onboarding.screen2()
            self.labelTitle.text = "INSTA-INCOME"
            self.labelText.text = "Freelancers, monetized your Instagram with increased local exposure to new clients!"
        case 2:
            self.imageView.image = R.image.onboarding.screen3()
            self.labelTitle.text = "INSTA-MAPPING"
            self.labelText.text = "Interactive maps, reveal freelancers current location and proximity in real-time!"
        default:
            break
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
