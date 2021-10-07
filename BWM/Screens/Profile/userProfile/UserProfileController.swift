//
//  UserProfileController.swift
//  BWM
//
//  Created by Serhii on 10/22/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SwiftyUserDefaults
import Flurry_iOS_SDK
import Alamofire

protocol UserProfileTabControllerDelegate: class {
    func didChangeContentHeight(_ height: CGFloat)
}

protocol UserProfileTabController {
    var tabType: UserProfileTabType { get }
    var delegate: UserProfileTabControllerDelegate? { get set }
}

enum UserProfileTabType: Int {
    case about
    case statistics
    case settings
    
    var title: String {
        switch self {
        case .about:
            return "About"
        case .statistics:
            return "Stats"
        case .settings:
            return "Settings"
        }
    }
}

class UserProfileController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var imageAvatar: UIImageView!
    @IBOutlet weak var imageConfirmed: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    @IBOutlet weak var labelPosts: UILabel!
    @IBOutlet weak var labelFollowers: UILabel!
    @IBOutlet private weak var labelTokens: UILabel?
    
    @IBOutlet private weak var buttonPro: UIButton?
    @IBOutlet private weak var viewSelector: SelectorComponent?
    @IBOutlet private weak var constraintEmbeddedHeight: NSLayoutConstraint!
    
    let getapiUrl = "http://93.188.167.68/projects/event_app/public/api/v1/accounts/nearByUsers"
    let instaFollow = "https://www.instagram.com/"
    var apiData = [AnyObject]()
    private var blurEffectView: UIVisualEffectView?
    private let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
    private var indicator: NVActivityIndicatorView?
    
    //MARK: - Properties
    fileprivate var pageController: UIPageViewController?
    
    var tabTypes: [UserProfileTabType] = []
    
    private var user: AuthObject?
    private var settings: Settings?
    
    var photos: [AlienPhotos] = []
    
    var isCurrentUserProfile: Bool {
        return true
    }
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLoadingView()
        
        let ab = UserDefaults.standard.value(forKey: "a") as? String
        print(ab)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getUser()
//        if isCurrentUserProfile {
//            Flurry.logEvent("UserProfileScreen_show")
//            self.updateUserData()
//        }
//        else {
//            Flurry.logEvent("AlienProfileScreen_show")
//        }
    }
    
//MARK: - USER GET API
    func getUser(){
        if Reachability.isConnectedToNetwork(){

            let username = UserDefaults.standard.value(forKey: "username") as? String ?? ""
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
    //MARK: - Test
    
    @IBAction private func onTestButton() {
        //self.tabBarController?.updateChatIcon(hasNewMsg: true)
        TestPNRequest.fire()
    }
    
    //MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == R.segue.userProfileController.userProfileEdit.identifier {
            return self.user != nil
        }
        
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navController = segue.destination as? UINavigationController,
            let screen = navController.viewControllers.first as? SignUpNameController {
            Flurry.logEvent("UserProfileScreen_edit")
            let userInfo = UserSetupModel()
            userInfo.isCustomer = self.user!.isCustomer ?? false
            userInfo.userData = self.user!.toDictionary()
            userInfo.isEditing = true
            userInfo.verificationCode = self.user!.verificationCode
            screen.userInfo = userInfo
        }
        else if segue.identifier == R.segue.userProfileController.showSubscription.identifier || segue.identifier == R.segue.userProfileController.showTokens.identifier {
            if let navController = segue.destination as? UINavigationController,
                let screen = navController.viewControllers.first as? TokenPurchaseController,
                let url = self.user?.avatarMedia?.url{
                screen.userImageLink = url
            }
        }
    }
    
    //MARK: - Public methods
    func updateUserData() {
        self.blockSelf()
        GetProfileRequest.fire { (completed, user) in
            if completed {
                self.user = user
                Defaults[.userIsPro] = user?.isPro ?? false
                Defaults[.liveTracking] = user?.settings?.tracking == 1 ? true : false
                GetSelfTokensRequest.fire(completion: { (completed) in
                    let userId = "\(self.user!.id)"
                    AlienPhotosRequest.fire(id: userId, completion: { (photos) in
                        self.photos = photos
                        
                        var tabs: [UserProfileTabType] = []
                        if self.photos.count > 0 || self.user?.locations?.count ?? 0 > 0 {
                            tabs.append(.about)
                        }
                        if self.user?.isCustomer == false {
                            tabs.append(.statistics)
                        }
                        tabs.append(.settings)
                        self.tabTypes = tabs
                        self.settings = user?.settings
                        
                        self.unblockSelf()
                        self.setupPageController()
                        self.updateUI()
//                        if let data = UserDefaults.standard.object(forKey: Constants.Key.userSettings) as? Data,
//                            let settings = NSKeyedUnarchiver.unarchiveObject(with: data) as? Settings {
//                            self.settings = settings
//
//                            self.unblockSelf()
//                            self.setupPageController()
//                            self.updateUI()
//                        }
//                        else {
//                            GetSettingsRequest.fire(completion: { (completed, settings) in
//                                if let settings = settings {
//                                    UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: settings), forKey: Constants.Key.userSettings)
//                                    self.settings = settings
//                                }
//
//                                self.unblockSelf()
//                                self.setupPageController()
//                                self.updateUI()
//                            })
//                        }
                    })
                })
            }
            else {
                self.unblockSelf()
            }
        }
    }
    
    func setupPageController() {
        if let controller = self.childViewControllers.first as? UIPageViewController {
            pageController = controller
            pageController?.dataSource = self
            pageController?.delegate = self
            
            if let type = self.tabTypes.first,
                let screen = self.itemForType(type) {
                pageController?.setViewControllers([screen], direction: .forward, animated: false, completion: nil)
            }
        }
    }
    
    func updateUI() {
        if let user = self.user {
            
            self.viewSelector?.updateWithButtons(buttonTitles: self.tabTypes.map({ (type) -> String in
                return type.title
            }))
            self.viewSelector?.delegate = self
            
            if let urlstring = user.avatarMedia?.thumbs?.x200 {
                let url = URL(string: urlstring)
                
                self.imageAvatar.kf.setImage(with: url, placeholder: R.image.profile.photoPlaceholder(), options: [.transition(.fade(0.35))], progressBlock: nil, completionHandler: nil)
            }
            
            self.imageAvatar.layer.borderColor = UIColor.lightGray.cgColor
            self.imageAvatar.layer.borderWidth = 1.0
            
            labelName.text = user.fullName
            labelPosts.text = user.postCount.roundedString
            labelFollowers.text = user.followerCount.roundedString
            labelDescription.text = user.shortDescription()
            
            if let tokens = TokensStore.shared.tokens {
                self.labelTokens?.text = tokens.roundedString
            }
            if user.isPro == true {
                buttonPro?.setImage(R.image.profile.proIcon(), for: .normal)
            }
            else {
                buttonPro?.setImage(R.image.profile.becomeProButton(), for: .normal)
            }
            if user.isVerified == true {
                self.imageConfirmed.image = R.image.search.badge_on()
            } else {
                self.imageConfirmed.image = R.image.search.badge_off()
            }
        }
    }
    
    func blockSelf() {
        indicator?.startAnimating()
        UIView.animate(withDuration: 0.25) {
            self.blurEffectView?.effect = self.blurEffect
            self.indicator?.alpha = 1.0
            self.view.setNeedsDisplay()
        }
    }
    
    func unblockSelf() {
        UIView.animate(withDuration: 0.25, animations: {
            self.blurEffectView?.effect = nil
            self.view.setNeedsDisplay()
            self.indicator?.alpha = 0.0
        }) { completed in
            self.indicator?.stopAnimating()
        }
    }
    
    func itemForType(_ type: UserProfileTabType) -> UIViewController? {
        if type == .about {
            if let screen = R.storyboard.profileBig.userAboutMeController(),
                let user = self.user,
                let locations = user.locations {
                screen.addresses = locations.sorted(by: { (loc1, loc2) -> Bool in
                    return loc1.isSelected == true
                })
                screen.photos = self.photos
                screen.userInfo = self.user?.about ?? ""
                screen.isPro = Defaults[.userIsPro] ?? false
                screen.userImageUrl = self.user?.avatarMedia?.url
                screen.delegate = self
                screen.isCurrentUser = self.isCurrentUserProfile
                return screen
            }
        }
        else if type == .statistics {
            if let screen = R.storyboard.profileBig.userStatsController(),
                let user = self.user {
                screen.user = user
                screen.delegate = self
                
                return screen
            }
        }
        else if type == .settings {
            if let screen = R.storyboard.profileBig.userSettingsController() {
                screen.delegate = self
                if let code = self.user?.verificationCode {
                    screen.confirmationCode = code
                }
                screen.settings = self.settings
                return screen
            }
        }
        
        return nil
    }
    
    //MARK: - Private methods
    
    private func setupLoadingView() {
        blurEffectView = UIVisualEffectView(effect: nil)
        blurEffectView?.frame = UIScreen.main.bounds
        
        blurEffectView?.isUserInteractionEnabled = false
        indicator?.alpha = 0.0
        
        let rect = CGRect(x: UIScreen.main.bounds.width / 2 - 80 / 2, y: UIScreen.main.bounds.height / 2 - 80 / 2, width: 80, height: 80)
        indicator = NVActivityIndicatorView(frame: rect, type: .ballGridPulse, color: UIColor.init(hex: 0xED4756), padding: 2)
        
        self.view.addSubview(blurEffectView!)
        blurEffectView?.contentView.addSubview(indicator!)
    }
}

extension UserProfileController: SelectorComponentViewDelegate {
    func selectedButtonWithIndex(_ index: Int) {
        let type = self.tabTypes[index]
        if let currentTabType = (self.pageController?.viewControllers?.first as? UserProfileTabController)?.tabType,
            currentTabType != type {
            let scrollDirection: UIPageViewControllerNavigationDirection = currentTabType.rawValue > type.rawValue ? .reverse : .forward
            if let item = self.itemForType(type) {
                self.pageController?.setViewControllers([item], direction: scrollDirection, animated: false, completion: nil)
            }
        }
    }
}

extension UserProfileController: UserProfileTabControllerDelegate {
    func didChangeContentHeight(_ height: CGFloat) {
        self.constraintEmbeddedHeight.constant = height
        self.view.layoutIfNeeded()
    }
}

extension UserProfileController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let screen = pageViewController.viewControllers?.first as? UserProfileTabController {
            if let index = self.tabTypes.firstIndex(of: screen.tabType) {
                self.viewSelector?.updateSelection(forIndex: index)
            }
        }
    }
}

extension UserProfileController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let tabType = (pageController?.viewControllers?.first as? UserProfileTabController)?.tabType else { return nil }
        
        guard let currentTabIndex = self.tabTypes.firstIndex(of: tabType),
            currentTabIndex > 0 else { return nil }
        let prevType = self.tabTypes[currentTabIndex-1]
        return self.itemForType(prevType)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let tabType = (pageController?.viewControllers?.first as? UserProfileTabController)?.tabType else { return nil }
        
        guard let currentTabIndex = self.tabTypes.firstIndex(of: tabType),
            tabType != self.tabTypes.last else { return nil }
        let nextType = self.tabTypes[currentTabIndex+1]
        return self.itemForType(nextType)
    }
}
