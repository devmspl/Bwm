//
//  AlienInformationController.swift
//  BWM
//
//  Created by Serhii on 10/28/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK
import DropDown
import Alamofire

class AlienInformationController: UserProfileController {
    
    
    var username = ""
    //MARK: - Outlets
    @IBOutlet private weak var buttonFavorite: UIButton!
    @IBOutlet private weak var buttonMessage: UIButton!
    
    @IBOutlet private weak var constraintProImageHeight: NSLayoutConstraint?
    
    //MARK: - Properties
    private var user: AlienAccount?
    private var isFavorite: Bool = false
    
    var userId: String!
    
    override var isCurrentUserProfile: Bool {
        return false
    }
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PurchaseUtils.shared.checkOnScreen(self, sCase: .profile)
        
       // self.updateUserData()
        getUserData()
    }
    
    
    // MARK: - API
    
    func getUserData(){
        if Reachability.isConnectedToNetwork(){

           
            Alamofire.request(instaFollow+username+"?__a=1",method: .get,encoding:  JSONEncoding.default).responseJSON{[self]
                response in
                switch(response.result){

                case .success(let json):do{
                    let success = response.response?.statusCode
                    let respond = json as! NSDictionary
//                    var abc = ""
                    if success == 200{
                        print("found",respond)
                        let graph = respond.object(forKey: "graphql") as? NSDictionary
                        let user = graph?.object(forKey: "user") as? NSDictionary
                        let follow = user!.object(forKey: "edge_followed_by") as? NSDictionary
                        let count = follow!.object(forKey: "count") as? Int ?? 0
                        let posDict = user!.object(forKey: "edge_owner_to_timeline_media") as! NSDictionary
                        let post = posDict.object(forKey: "count") as? Int ?? 0
                        postData = posDict.object(forKey: "edges") as! [AnyObject]
//                        self.postCollection.reloadData()
                        print("countttt===",count)
                        labelPosts.text = "\(post)"
                        labelFollowers.text = "\(count)"
                        labelName.text = user!.object(forKey: "full_name") as? String ?? "Name"
                        if let image = user!.object(forKey: "profile_pic_url") as? String{
                         
                              if image != ""{
                                                            DispatchQueue.main.async {
                                                                let url = URL(string: image)
                                                                self.imageAvatar.af_setImage(withURL: url!)
                                                            }
                              }else{
                                DispatchQueue.main.async {
                                    let url = URL(string: "http://93.188.167.68/projects/event_app/public/default.jpgg")
                                    self.imageAvatar.af_setImage(withURL: url!)
                              }
                                                
                        
                        }
                        }
                        UserDefaults.standard.setValue(count, forKey: "follow")
                        
                    }else{
                        self.view.isUserInteractionEnabled = true
                    }
                }

                case .failure(let error):do{
                    print(error)
                    self.view.isUserInteractionEnabled = true
                }
                }
            }
        }else{
            Alerts.showNoConnectionErrorMessage()
        }
    }
    //MARK: - Actions
    
    @IBAction private func onMore() {
        let dropDown = DropDown()
        
        dropDown.anchorView = navigationItem.rightBarButtonItem
        dropDown.dataSource = ["Report"]
        dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            let alertController = UIAlertController(title: "", message: "This page will be checked for compliance with the rules. Thank you for helping us make this a great community!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] (action) in
                if let uid = self?.userId {
                    ReportAccountRequest.fire(userId: uid, completion: { (success, msg) in
                        if success {
                            NotificationCenter.default.post(name: NSNotification.Name("ShouldReloadUsers"), object: nil)
                            self?.navigationController?.popViewController(animated: true)
                        }
                    })
                }
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self?.present(alertController, animated: true, completion: nil)
        }
        dropDown.direction = .bottom
        dropDown.width = 200
        dropDown.bottomOffset = CGPoint(x: 0, y:dropDown.anchorView?.plainView.bounds.height ?? 0)
        dropDown.show()
    }
    
    @IBAction private func onMessageButton() {
        if self.user?.hasContact == true,
            let uId = self.user?.id {
            self.startChat(withUser: uId)
            Flurry.logEvent("AlienProfileScreen_startChat")
        }
        else {
            self.blockSelf()
            GetSelfTokensRequest.fire { [weak self] (success) in
                self?.unblockSelf()
                if let tokens = TokensStore.shared.tokens,
                    tokens > 0 {
                    self?.showStartChatAlert()
                }
                else {
                    self?.showBuyTokensAlert()
                }
            }
        }
    }
    
    @IBAction private func onFavoriteButton() {
        self.blockSelf()
        guard let id = Int(self.userId) else { return }
        if self.isFavorite {
            Flurry.logEvent("AlienProfileScreen_removeFavorite")
            RemoveFromFavouritesRequest.fire(id: id) { (completed) in
                if completed {
                    self.buttonFavorite.setImage(R.image.profile.heart_default(), for: .normal)
                    self.isFavorite = false
                    self.unblockSelf()
                }
            }
        }
        else {
            Flurry.logEvent("AlienProfileScreen_addFavorite")
            AddToFavouritesRequest.fire(id: id) { (completed) in
                if completed {
                    self.buttonFavorite.setImage(R.image.profile.heartHL(), for: .normal)
                    self.isFavorite = true
                    self.unblockSelf()
                    
                    PurchaseUtils.shared.checkOnScreen(self, sCase:.addFavorites)
                }
            }
        }
    }
    
    //MARK: - Private methods
    
    private func showStartChatAlert() {
        Flurry.logEvent("AlienProfileScreen_showStartChatAlert")
        if let userId = self.user?.id {
            let alertController = UIAlertController(title: "", message: "Starting chat costs 2 tokens", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak self, userId] (action) in
                self?.startChat(withUser: userId)
            }))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func startChat(withUser userId: Int) {
        if let screen = R.storyboard.chat.chatController() {
            screen.userId = userId
            screen.avatarUrl = self.user?.avatarMedia?.thumbs?.x200
            screen.hidesBottomBarWhenPushed = true
            
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
    private func showBuyTokensAlert() {
        let alertController = UIAlertController(title: "", message: "You haven't enough tokens to chat. Purchase?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: {(action) in
            //TODO: BUY TOKENS
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Overrides
    
//    override func updateUserData() {
//        self.blockSelf()
//
//        AlienAccountRequest.fire(id: userId) { (account, success) in
//            if success {
//                self.user = account
//                self.isFavorite = self.user?.isFavorite ?? false
//                self.constraintProImageHeight?.constant = account?.isPro == true ? 40.0 : 0.0
//                AlienPhotosRequest.fire(id: self.userId, completion: { (photos) in
//                    self.photos = photos
//                    self.unblockSelf()
//
//                    var tabs: [UserProfileTabType] = []
//                    if self.photos.count > 0 || self.user?.locations?.count ?? 0 > 0 {
//                        tabs.append(.about)
//                    }
//                    self.tabTypes = tabs
//                    self.setupPageController()
//                    self.updateUI()
//                })
//            }
//            else {
//                self.unblockSelf()
//            }
//        }
//    }
    
    override func updateUI() {
        self.buttonMessage.layer.borderColor = UIColor.lightGray.cgColor
        self.buttonMessage.layer.borderWidth = 1.0
        
        if let user = self.user {
            if let urlstring = user.avatarMedia?.thumbs?.x200 {
                let url = URL(string: urlstring)
                
                self.imageAvatar.kf.setImage(with: url, placeholder: R.image.profile.photoPlaceholder(), options: [.transition(.fade(0.35))], progressBlock: nil, completionHandler: nil)
            }
            self.title = self.user?.category?.name
            self.imageAvatar.layer.borderColor = UIColor.lightGray.cgColor
            self.imageAvatar.layer.borderWidth = 1.0
            let name = user.hasContact ? user.fullName : user.firstName
            labelName.text = name
            labelPosts.text = user.postCount?.roundedString
            labelFollowers.text = user.followerCount?.roundedString
            labelDescription.text = user.shortDescription()
            
            self.buttonFavorite.setImage(user.isFavorite ? R.image.profile.heartHL() : R.image.profile.heart_default(), for: .normal)
            
            if user.isVerified == true {
                self.imageConfirmed.image = R.image.search.badge_on()
            } else {
                self.imageConfirmed.image = R.image.search.badge_off()
            }
        }
    }
    
    override func itemForType(_ type: UserProfileTabType) -> UIViewController? {
        if type == .about {
            if let screen = R.storyboard.profileBig.userAboutMeController(),
                let user = self.user {
                if let locations = user.locations {
                    screen.addresses = locations
                }
                screen.photos = self.photos
                screen.userInfo = self.user?.about ?? ""
                screen.delegate = self
                screen.userImageUrl = self.user?.avatarMedia?.url
                return screen
            }
        }
        
        return nil
    }
}
