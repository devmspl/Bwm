//
//  UserSearchController.swift
//  BWM
//
//  Created by Serhii on 10/30/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import Flurry_iOS_SDK

class UserSearchController: BaseViewController {

    //MARK: - Outlets
    @IBOutlet private weak var collectionHeader: UICollectionView!
    @IBOutlet private weak var buttonScreenMode: UIBarButtonItem!
    
    @IBOutlet private weak var constraintGridWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraintMapWidth: NSLayoutConstraint!
    @IBOutlet private weak var constraintHeaderHeight: NSLayoutConstraint!
    
    @IBOutlet private weak var viewTranslucentStatusbar: UIView!
    
    //MARK: - Properties
    fileprivate var users: [SearchObject] = []
    fileprivate var isListMode: Bool = false
    
    private var timer: Timer?
    private var currentOffset: CGFloat = 0.0
    private var isHeaderFullSize: Bool = true
    
    private var usersGridController: UserGridController?
    private var usersMapController: MapController?
    
    //MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "SEARCH"
        self.tabBarController?.removeTabbarItemsText()
        
        self.constraintMapWidth.constant = UIScreen.main.bounds.width
        self.constraintGridWidth.constant = 0.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(onShouldReload), name: NSNotification.Name("ShouldReloadUsers"), object: nil)
        
        if let token = Defaults[.pnToken] {
            RegisterPushTokenRequest.fire(token: token, completion: { (completion) in
                print("Registration for PN - \(completion)")
            })
        }
        if GraphStatsStore.shared.stats == nil {
            self.unblockView()
            print("graph")
//            GraphStatsRequest.fire(id: "", completion: { (object) in
//                self.unblockView()
//
//                if let uId = Store.shared.userIdFromVideo {
//                    self.showUser(withId: uId)
//                    Store.shared.userIdFromVideo = nil
//                }
//            })
        }
        
        PurchaseUtils.shared.checkOnScreen(self, sCase: .tutorial)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logEvent("FrontPage_show")
        //self.blockView()
        self.updateUsers(completion: nil)
        if timer?.isValid != true {
            self.runTimer()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
    }
    
    // MARK: - Actions
    
    @IBAction private func onFilterButton() {
        Flurry.logEvent("FrontPage_filter")
       let controller = Storyboards.Search.instantiateFilterController()
        self.navigationController?.pushViewController(controller, animated: true)
        PurchaseUtils.shared.checkOnScreen(controller, sCase: .search)
    }
    
    @IBAction private func onModeButton() {
        self.isListMode = !self.isListMode
        self.buttonScreenMode.image = self.isListMode ? R.image.search.mapButton() : R.image.search.listButton()
        self.buttonScreenMode.isEnabled = false
        UIView.animate(withDuration: 0.5, animations: {
            if self.isListMode {
                Flurry.logEvent("FrontPage_showList")
                self.constraintMapWidth.constant = 0.0
                self.constraintGridWidth.constant = UIScreen.main.bounds.width
                
                self.usersGridController?.updateGrid()
            }
            else {
                Flurry.logEvent("FrontPage_showMap")
                self.isHeaderFullSize = true
                self.updateHeaderHeight()
                self.constraintMapWidth.constant = UIScreen.main.bounds.width
                self.constraintGridWidth.constant = 0.0
            }
            self.view.layoutIfNeeded()
        }) { (completed) in
            self.buttonScreenMode.isEnabled = true
        }
    }
    
    // MARK: - Private methods
    
    private func runTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.updateUsersTimed), userInfo: nil, repeats: true)
    }
    
    @objc private func updateUsersTimed() {
        self.updateUsers(completion: nil)
    }
    
    @objc private func onShouldReload() {
        blockView()
        updateUsers { [weak self] in
            DispatchQueue.main.async {
                self?.usersGridController?.updateGrid()
            }
        }
    }
    
    @objc private func updateUsers(completion: (()->Void)?) {
//        let obj = SearchStore.shared.filterObject
//        obj.isInitial = false
//        SearchRequest.fire(data: obj.toDictionary()) { (users) in
//            self.unblockView()
//            self.users = self.sortedUsers(users)
//            self.collectionHeader.reloadData()
//            self.usersGridController?.updateWithUsers(self.users)
//            self.usersMapController?.setUsers(self.users)
//            completion?()
//        }
    }
    
    private func sortedUsers(_ users: [SearchObject]) -> [SearchObject] {
        if users.count > 3 {
            var users: [SearchObject] = users
            var sorted: [SearchObject] = []
            
            sorted.append(users.removeFirst())
            sorted.append(users.removeFirst())
            sorted.append(users.removeFirst())
            
            let liveUsers = users.compactMap { (obj) -> SearchObject? in
                return obj.point != nil ? obj : nil
            }
            
            sorted.append(contentsOf: liveUsers)
            
            for user in liveUsers{
                users.removeAll { (obj) -> Bool in
                    user === obj
                }
            }
            
            let proUsers = users.compactMap { (obj) -> SearchObject? in
                return obj.isPro == true ? obj : nil
            }
            
            sorted.append(contentsOf: proUsers)
            
            for user in proUsers{
                users.removeAll { (obj) -> Bool in
                    user === obj
                }
            }
            
            sorted.append(contentsOf: users)
            
            return sorted
        }
        else {
            return users
        }
    }
    
    private func moveToTop() {
        let alertController = UIAlertController(title: "", message: "Moving to top costs 2 tokens", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak self] (action) in
            self?.blockView()
            GetSelfTokensRequest.fire { (success) in
                Flurry.logEvent("FrontPage_buyBecome1st")
                if let tokens = TokensStore.shared.tokens,
                    tokens > 1 {
                    MoveToTopRequest.fire(completion: { (success) in
                        self?.updateUsers(completion: {
                            if self?.isListMode == true {
                                self?.usersGridController?.updateGrid()
                            }
                        })
                        self?.unblockView()
                        if success {
                            Alerts.showCustomErrorMessage(title: "Success", message: "", button: "OK")
                        }
                    })
                }
                else {
                    self?.unblockView()
                    let alert = UIAlertController(title: "You do not have enough tokens", message: "Do you want to buy more tokens?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                    alert.addAction(UIAlertAction(title: "Buy", style: .default, handler: { _ in
                        if let screen = R.storyboard.profileBig.tokenPurchaseController() {
                            self?.present(screen, animated: true, completion: nil)
                        }
                    }))
                    self?.present(alert, animated: true)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        Flurry.logEvent("FrontPage_tapBecome1st")
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showUser(withId id: Int) {
        if let screen = R.storyboard.profileBig.alienInformationController() {
            screen.userId = "\(id)"
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.userSearchController.userGridController.identifier {
            self.usersGridController = segue.destination as? UserGridController
            self.usersGridController?.delegate = self
        }
        else if segue.identifier == R.segue.userSearchController.userMapController.identifier {
            self.usersMapController = segue.destination as? MapController
        }
    }
}

extension UserSearchController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.users.count + 1
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.userHeaderCell.identifier, for: indexPath) as! UserHeaderCell
        
        if indexPath.row == 0 {
            cell.setData(title: "Become 1st", image: "", fill: false, hasBadge: false)
        } else {
//            let user = self.users[indexPath.row - 1]
//            let imageString = user.avatarMedia?.thumbs?.x200 ?? ""
//            let nameString = user.category?.name ?? ""
//            let verified = user.isVerified ?? false
//
//            if user.point != nil && user.isPro == true {
//                cell.animate()
//            }
            
//            cell.setData(title: nameString, image: imageString, fill: true, hasBadge: verified)
        }
        
        return cell
    }
    
    
}

extension UserSearchController: UserGridControllerDelegate {
    func didScroll(toTop: Bool) {
        self.isHeaderFullSize = toTop
        self.updateHeaderHeight()
    }
    
    fileprivate func updateHeaderHeight() {
        UIView.animate(withDuration: 0.25, animations: {
            self.constraintHeaderHeight.constant = self.isHeaderFullSize ? 110.0 : 85.0
        }) { _ in
            self.collectionHeader.collectionViewLayout.invalidateLayout()
        }
    }
}

extension UserSearchController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 75.0, height: (isHeaderFullSize ? 110.0 : 75.0))
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.row == 0 {
//            self.moveToTop()
//        }
//        else {
//            if let userId = self.users[indexPath.row-1].id {
//                self.showUser(withId: userId)
//            }
//        }
//    }
}
