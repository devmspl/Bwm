//
//  UserAboutMeController.swift
//  BWM
//
//  Created by Serhii on 10/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import Kingfisher
import AVKit
import Flurry_iOS_SDK

class UserAboutMeController: UIViewController, UserProfileTabController {
    
    //MARK: - Tab controller
    var tabType: UserProfileTabType {
        return .about
    }
    
    weak var delegate: UserProfileTabControllerDelegate?
    
    //MARK: - Outlets
    @IBOutlet private weak var labelAbout: UILabel!
    @IBOutlet private weak var collectionData: UICollectionView!
    
    var addresses: [Locations] = []
    var photos: [AlienPhotos] = []
    var userInfo: String = ""
    var userImageUrl: String?
    
    var isPro: Bool = false
    var isCurrentUser: Bool = false
    var selectedModeGrid: Bool = true
    var locationsExpanded: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.labelAbout.text = userInfo
        self.collectionData.prefetchDataSource = self
        self.collectionData.register(R.nib.photoModeReusableView(),
                                     forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                     withReuseIdentifier: R.reuseIdentifier.photoModeReusableView.identifier)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionData.reloadData()
        self.changedContentHeight()
        Flurry.logEvent(isCurrentUser ? "UserProfileScreen_showAbout": "AlienProfileScreen_showAbout")
    }
    
    //MARK: - Private methods
    
    fileprivate func changedContentHeight() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            var height = self.labelAbout.frame.size.height + 10.0
            height += self.collectionData.contentSize.height
            self.delegate?.didChangeContentHeight(height)
        }
    }
}

extension UserAboutMeController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let urls = self.photos.compactMap { (photo) -> URL? in
            return URL(string: photo.pictureUrl ?? "")
        }
        ImagePrefetcher(urls: urls).start()
    }
}

extension UserAboutMeController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return self.addresses.count > 0 ? CGSize(width: collectionView.frame.size.width, height: 30.0) : CGSize.zero
        }
        else {
            return self.photos.count > 0 ? CGSize(width: collectionView.frame.size.width, height: 51.0) : CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize.zero
        
        if indexPath.section == 0 {
            size.width = collectionView.frame.size.width
            size.height = 100
        }
        else {
            if selectedModeGrid {
                size.width = (collectionView.frame.size.width - 2.0)/3.0
                size.height = size.width
            }
            else {
                if let photoUrl = self.photos[indexPath.row].pictureUrl {
                    let cache = ImageCache.default.imageCachedType(forKey: photoUrl)
                    var image: UIImage?
                    if cache == .disk {
                        image = ImageCache.default.retrieveImageInDiskCache(forKey: photoUrl)
                    }
                    else if cache == .memory {
                        image = ImageCache.default.retrieveImageInMemoryCache(forKey: photoUrl)
                    }
                    if let image = image {
                        let aspectRatio = image.size.width / image.size.height
                        size.width = self.view.frame.size.width
                        size.height = (size.width / aspectRatio) + 95.0
                    }
                }
                else {
                    size.width = collectionView.frame.size.width
                    size.height = 100.0
                }
            }
        }
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
        else {
            return UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.selectedModeGrid ? 1.0 : 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            Flurry.logEvent(isCurrentUser ? "UserProfileScreen_about_showLocation": "AlienProfileScreen_about_showLocation")
            let location = LocationModel(withLocation: self.addresses[indexPath.row])
            if let vc = R.storyboard.selection.selectLocationController() {
                vc.locationToShow = location
                vc.selectionEnabled = false
                vc.canShowRoute = !self.isCurrentUser
                vc.canManageSelectedLocation = self.isCurrentUser
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
                
                if !isCurrentUser {
                    PurchaseUtils.shared.checkOnScreen(vc, sCase: .alienLocation)
                }
            }
        }
        else if indexPath.section == 1 {
            Flurry.logEvent(isCurrentUser ? "UserProfileScreen_about_showMedia": "AlienProfileScreen_about_showMedia")
            if let videoUrl = self.photos[indexPath.row].videoUrl,
                let url = URL(string: videoUrl){
                let player = AVPlayer(url: url)
                let playerViewController = AVPlayerViewController()
                playerViewController.modalPresentationStyle = .overFullScreen
                playerViewController.player = player
                if let screen = self.parent?.parent {
                    screen.present(playerViewController, animated: true) {
                        playerViewController.player!.play()
                    }
                }
            }
            else if let photoUrl = self.photos[indexPath.row].pictureUrl {
                let vc = Storyboards.Search.instantiatePhotoPreviewController()
                vc.imageUrl = photoUrl
                vc.userImageUrl = self.userImageUrl
                self.navigationController?.pushViewController(vc, animated: true)
                
                if !isCurrentUser {
                    PurchaseUtils.shared.checkOnScreen(vc, sCase: .alienMedia)
                }
            }
        }
    }
}

extension UserAboutMeController: PhotoModeReusableViewDelegate {
    func didSelectMode(_ mode: PhotoMode) {
        let current: PhotoMode = self.selectedModeGrid ? .modeGrid : .modeList
        if current != mode {
            Flurry.logEvent(isCurrentUser ? "UserProfileScreen_about_\(mode.rawValue)": "AlienProfileScreen_about_\(mode.rawValue)")
            self.selectedModeGrid = mode == .modeGrid
            self.collectionData.reloadSections(IndexSet(integer: 1))
            self.changedContentHeight()
        }
    }
}

extension UserAboutMeController: LocationHeaderDelegate {
    func didTapExpandButton() {
        Flurry.logEvent(isCurrentUser ? "UserProfileScreen_about_expand": "AlienProfileScreen_about_expand")
        self.locationsExpanded = !self.locationsExpanded
        
        self.collectionData.reloadSections(IndexSet(integer: 0))
        self.changedContentHeight()
    }
    
    func didTapAddLocationButton() {
        if let screen = R.storyboard.selection.selectLocationController() {
            Flurry.logEvent("UserProfileScreen_about_addLocation")
            screen.delegate = self
            screen.canManageSelectedLocation = false
            parent?.navigationController?.pushViewController(screen, animated: true)
        }
    }
}

extension UserAboutMeController: SelectLocationControllerDelegate {
    func didSelectLocation(_ location: LocationModel) {
        AddLocationRequest.fire(data: location.dictionary) { (success) in
            if let screen = self.parent?.parent as? UserProfileController {
                screen.updateUserData()
            }
        }
    }
    
    func didRemoveLocation() {
        if let screen = self.parent?.parent as? UserProfileController {
            screen.updateUserData()
        }
    }
}

extension UserAboutMeController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        if section == 0 {
            if addresses.count > 0 {
                count = self.locationsExpanded ? addresses.count : 1
            }
        }
        else {
            count = photos.count
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if indexPath.section == 0 {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: R.reuseIdentifier.locationTitleView.identifier, for: indexPath) as! LocationHeaderReusableView
            
            view.delegate = self
            view.shouldShowExpandButton(self.addresses.count > 1)
            view.shouldShowAddButton(self.isPro)
            view.setExpanded(self.locationsExpanded)
            return view
        }
        else {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: R.reuseIdentifier.photoModeReusableView.identifier, for: indexPath) as! PhotoModeReusableView
            view.delegate = self
            view.updateWithMode(self.selectedModeGrid ? .modeGrid : .modeList)
            return view
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let adress = addresses[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.userLocationCell.identifier,
                                                          for: indexPath) as! UserLocationCell
            cell.updateWithAdress(adress)
            let showSeparator = (indexPath.row < addresses.endIndex-1) && self.locationsExpanded
            cell.setShowSeparator(showSeparator)
            cell.setSelected(adress.isSelected)
            
            return cell
        }
        else {
            let photo = photos[indexPath.row]
            let cellId = selectedModeGrid ? R.reuseIdentifier.userPhotoGridCell.identifier : R.reuseIdentifier.userPhotoListCell.identifier
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! UserPhotoCell
            
            if selectedModeGrid {
                cell.updateWithPhoto(photo, isList: false)
            }
            else {
                cell.updateWithPhoto(photo, isList: true) {[indexPath] in
                    self.collectionData.reloadItems(at: [indexPath])
                }
            }
            
            return cell
        }
    }
}
