//
//  MainScreenController.swift
//  BWM
//
//  Created by obozhdi on 04/05/2018.
//  Copyright © 2018 obozhdi. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

extension UITabBarController {
    func removeTabbarItemsText() {
        tabBar.items?.forEach {
            $0.title = ""
            $0.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            $0.titlePositionAdjustment = UIOffset(horizontal: 0.0, vertical: 5.0)
        }
    }
    
    func updateChatIcon(messageCount count: Int) {
        if let tab = self.tabBar.items?[1] {
            tab.image = count > 0 ? R.image.tabbar.chat_hl()?.withRenderingMode(.alwaysOriginal) : R.image.tabbar.chat_default()
            tab.badgeValue = count > 0 ? "\(count)" : nil
            UIApplication.shared.applicationIconBadgeNumber = count
        }
    }
}

class MainTabbarController: BaseTabbarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(onNewMessage), name: NSNotification.Name(rawValue: Constants.Notification.newMessage), object: nil)
        
        setupTabbar()
        self.removeTabbarItemsText()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    @objc private func onNewMessage(_ notification: Notification) {
        if self.selectedIndex != 1 {
            if let count = notification.userInfo?[Constants.Key.messageCount] as? Int {
                self.updateChatIcon(messageCount: count)
            }
        }
    }
    
    private func setupTabbar() {
        self.tabBar.backgroundColor = UIColor.init(hex: 0xFAFAFA)
        self.tabBar.isTranslucent   = false
        
        let searchController       = Storyboards.Search.instantiateInitialViewController()
        let chatController         = Storyboards.Chat.instantiateInitialViewController()
        let favouritesController   = Storyboards.Favourites.instantiateInitialViewController()
        let profileBigController   = Storyboards.ProfileBig.instantiateInitialViewController()
        
        let searchTabItem = UITabBarItem(title: "",
                                         image: R.image.tabbar.search_default(),
                                         selectedImage: R.image.tabbar.search_hl())
        
        let chatTabItem = UITabBarItem(title: "",
                                       image: R.image.tabbar.chat_default(),
                                       selectedImage: R.image.tabbar.chat_hl())
        
        let favouritesTabItem = UITabBarItem(title: "",
                                             image: R.image.tabbar.favourites_default(),
                                             selectedImage: R.image.tabbar.favourites_hl())
        
        let profileTabItem = UITabBarItem(title: "",
                                          image: R.image.tabbar.profile_default(),
                                          selectedImage: R.image.tabbar.profile_hl())
        
        searchController.tabBarItem       = searchTabItem
        chatController.tabBarItem         = chatTabItem
        favouritesController.tabBarItem   = favouritesTabItem
        profileBigController.tabBarItem   = profileTabItem
        
        viewControllers = [searchController, chatController, favouritesController, profileBigController]
        
//        if Defaults[.userType]! == "customer" {
//            viewControllers = [searchController, chatController, favouritesController, profileBigController]
//        } else {
//            viewControllers = [searchController, chatController, favouritesController, profileBigController]
//        }
        
        if Store.shared.receivedMessagePushNotification != nil ||
            Store.shared.deepLinkChatUserId != nil {
            self.selectedIndex = 1
        }
        
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedStringKey.foregroundColor: UIColor.appRed,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20.0)
            ], for: .normal)
        
        tabBar.barTintColor  = .white
        tabBar.tintColor     = UIColor.init(hex : 0xAF37A9)
        tabBar.isTranslucent = false
    }
    
}
