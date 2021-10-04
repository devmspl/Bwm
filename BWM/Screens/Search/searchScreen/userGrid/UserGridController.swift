//
//  UserGridController.swift
//  BWM
//
//  Created by Serhii on 10/30/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

protocol UserGridControllerDelegate: class {
    func didScroll(toTop: Bool)
}

class UserGridController: UICollectionViewController {

    weak var delegate: UserGridControllerDelegate?
    
    private var contentFlowLayout: UserGridLayout = UserGridLayout()
    private var users: [SearchObject] = []
    private var sortedUsers: [SearchObject] = []
    private var topUserIndexes: [Int] = []
    
    private var currentOffset: CGFloat = 0.0
    let image = [UIImage(named: "a"),UIImage(named: "b"),UIImage(named: "c"),UIImage(named: "d"),UIImage(named: "e")]
    let follow = ["200 followers","600 followers","400 followers","1500 followers","1K followers"]
    let verify = [UIImage(named: "Search/badge_off"),UIImage(named: "Search/badge_on"),UIImage(named: "Search/badge_on"),UIImage(named: "Search/badge_on"),UIImage(named: "Search/badge_off")]
    override func viewDidLoad() {
        super.viewDidLoad()
        contentFlowLayout.delegate = self
        contentFlowLayout.contentPadding = ItemsPadding(horizontal: 0, vertical: 110)
        contentFlowLayout.cellsPadding = ItemsPadding(horizontal: 1, vertical: 1)
        contentFlowLayout.contentAlign = .right
        
        collectionView?.collectionViewLayout = contentFlowLayout
        collectionView?.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.collectionView?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.collectionView?.delegate = nil
    }
    
    // MARK: - Public methods
    
    func updateWithUsers(_ users: [SearchObject]) {
        self.users = users
//        self.sortUsers()
//        self.collectionView?.reloadData()
    }
    
    func updateGrid() {
        self.sortUsers()
        self.collectionView?.reloadData()
    }
    
    // MARK: - Private methods
    
    private func sortUsers() {
        let proUsers = self.users.filter { (obj) -> Bool in
            return obj.isPro ?? false
        }
        let users = self.users.filter { (obj) -> Bool in
            return obj.isPro != true
        }
        
        var sortedProUsers = proUsers.sorted { (obj1, obj2) -> Bool in
            return obj1.position > obj2.position
        }
        var sortedUsers = users.sorted { (obj1, obj2) -> Bool in
            return obj1.position > obj2.position
        }
        
        sortedUsers.shuffle()
        
        topUserIndexes.removeAll()
        if sortedProUsers.count > 0 {
            var index = 0
            for i in 1..<sortedProUsers.endIndex {
                if i % 2 == 0 {
                    index += 7
                }
                else {
                    index += 11
                }
                topUserIndexes.append(index)
            }
        }
        
        if sortedProUsers.count > 0 {
            sortedUsers.insert(sortedProUsers.removeFirst(), at: 0)
            for index in topUserIndexes {
                if index < sortedUsers.endIndex {
                    sortedUsers.insert(sortedProUsers.removeFirst(), at: index)
                }
                else {
                    sortedUsers.append(sortedProUsers.removeFirst())
                }
            }
        }
        
        self.sortedUsers = sortedUsers
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.sortedUsers.count
        return image.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.userGridCell.identifier, for: indexPath) as! UserGridCell
        cell.imageAvatar.image = image[indexPath.row]
        cell.labelFollowersCount.text = follow[indexPath.row]
        cell.imageVerified.image = verify[indexPath.row]
//        cell.layer.shouldRasterize = true;
//        cell.layer.rasterizationScale = UIScreen.main.scale
//
//        let item = self.sortedUsers[indexPath.row]
//
//        let isTop = topUserIndexes.contains { (index) -> Bool in
//            return indexPath.item == index
//        }
//
//        let image = /*isTop || indexPath.item == 0 ?*/ item.avatarMedia?.url// : item.avatarMedia?.thumbs?.x300
//
//        cell.setData(image: image ?? "", followers: item.followerCount, verified: item.isVerified ?? false)

        return cell
    }
    
    // MARK: UIScrollViewDelegate
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentOffset = self.collectionView?.contentOffset.y ?? 0.0
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let offset = self.collectionView?.contentOffset.y {
            if offset > currentOffset+60.0 {
                self.delegate?.didScroll(toTop: false)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }
            else if offset+60.0 < currentOffset {
                self.delegate?.didScroll(toTop: true)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            }
        }
    }

    // MARK: UICollectionViewDelegate
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if let screen = R.storyboard.profileBig.alienInformationController(),
//            let userId = self.sortedUsers[indexPath.row].id {
//            screen.userId = "\(userId)"
//            Flurry.logEvent("FrontPage_list_selectUser")
//            self.navigationController?.pushViewController(screen, animated: true)
//        }
//    }
}

extension UserGridController: UserGridLayoutDelegate {
    func cellSize(indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width-2.0)/3.0
        return CGSize(width: width, height: width)
    }
}
