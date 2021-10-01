//
//  SearchRootController.swift
//  BWM
//
//  Created by obozhdi on 16/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class SearchRootController: BaseViewController {
    
    @IBOutlet private weak var linearCollection    : UICollectionView!
    @IBOutlet private weak var bigCollection       : UICollectionView!
    @IBOutlet private weak var bigCollectionLayout : SearchLayout!
    @IBOutlet private weak var mapButton: UIButton!
    @IBOutlet weak var mapContainer: UIView!
    
    private var timer: Timer?
    
    private var mapIsHidden: Bool = false {
        didSet {
            if mapIsHidden == true {
                mapButton.setImage(R.image.search.mapButton(), for: .normal)
            } else {
                mapButton.setImage(R.image.search.listButton(), for: .normal)
            }
            mapContainer.isHidden = mapIsHidden
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = Defaults[.pnToken] {
            RegisterPushTokenRequest.fire(token: token, completion: { (completion) in
                print("Registration for PN - \(completion)")
            })
        }
        
        self.title = "SEARCH"
        self.tabBarController?.removeTabbarItemsText()
        
        bigCollectionLayout.delegate           = self
        bigCollectionLayout.itemSpacing        = 1
        bigCollectionLayout.fixedDivisionCount = 3
        bigCollectionLayout.scrollDirection    = .vertical
        bigCollection.setCollectionViewLayout(bigCollectionLayout, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.blockView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        SearchRequest.fire(data: SearchStore.shared.filterObject.toDictionary()) { users in
            self.bigCollection.reloadData()
            self.linearCollection.reloadData()
            
            if GraphStatsStore.shared.stats == nil {
                GraphStatsRequest.fire(id: "", completion: { (object) in
                    print("GRID - \(SearchStore.shared.users.count)")
                    self.unblockView()
                    
                    if let uId = Store.shared.userIdFromVideo {
                        self.showUser(withId: uId)
                        Store.shared.userIdFromVideo = nil
                    }
                })
            }
            else {
                self.unblockView()
            }
        }
    }
    
    @IBAction func tapShowFilter(_ sender: Any) {
        TestPNRequest.fire()
        //blockView()
       // 
    }
    
    @IBAction func tapMapButton(_ sender: Any) {
        mapIsHidden = !mapIsHidden
    }
    
    private func moveToTop() {
        let alertController = UIAlertController(title: "", message: "Moving to top costs 1 token", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: { [weak self] (action) in
            self?.blockView()
            GetSelfTokensRequest.fire { (success) in
                if let tokens = TokensStore.shared.tokens,
                    tokens > 0 {
                    MoveToTopRequest.fire(completion: { (success) in
                        self?.unblockView()
                        if success {
                            Alerts.showCustomErrorMessage(title: "Success", message: "", button: "OK")
                        }
                    })
                }
                else {
                    self?.unblockView()
                    let alert = UIAlertController(title: "You do not have enough tokens", message: "Do you want to buy more tokens?", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (aaa) in
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Buy", style: .default, handler: { (aaa) in
                        self?.present(Storyboards.ProfileBig.instantiateViewController(withIdentifier: "SubscriptionsController"), animated: true, completion: nil)
                    }))
                    self?.present(alert, animated: true)
                }
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showUser(withId id: Int) {
        if let screen = R.storyboard.profileBig.alienInformationController() {
            screen.userId = "\(id)"
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
}

extension SearchRootController: SearchLayoutDelegate {
    
    func scaleForItem(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndexPath indexPath: IndexPath) -> UInt {
        return scale(index: indexPath.row)
    }
    
    func itemFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return fixedDimension
    }
    
    private func scale(index: Int) -> UInt {
        if index == 0 {
            return 1
        }
        else {
            return UInt(SearchStore.shared.layouts[index-1])
        }
    }
    
}

extension SearchRootController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == linearCollection {
            return CGSize(width: 80, height: 90) //
        }
        
        let size = bigCollection.frame.width / 3
        
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == linearCollection {
            return 0.0
        }
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == linearCollection {
            return SearchStore.shared.users.count + 1
        }
        else {
            return SearchStore.shared.users.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == linearCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchHorizontalCell.self), for: indexPath) as! SearchHorizontalCell
            if indexPath.row == 0 {
                cell.setData(title: "Become 1st", image: "", fill: false, hasBadge: false)
            } else {
                if SearchStore.shared.users.count > indexPath.row-1 {
                    let imageString1 = SearchStore.shared.users[indexPath.row-1].avatarMedia?.thumbs?.x200 ?? ""
                    let nameString = SearchStore.shared.users[indexPath.row-1].category?.name ?? "None"
                    let verified = SearchStore.shared.users[indexPath.row-1].isVerified ?? false
                    
                    cell.setData(title: nameString, image: imageString1, fill: true, hasBadge: verified)
                }
            }
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SearchBigCell.self), for: indexPath) as! SearchBigCell
        
        let imageString = SearchStore.shared.users[indexPath.row].avatarMedia?.thumbs?.x200 ?? ""
        let followersString = SearchStore.shared.users[indexPath.row].followerCount ?? 0
        let verified = SearchStore.shared.users[indexPath.row].isVerified ?? false
        
        cell.setData(image: imageString, followers: "Followers: " + (followersString.roundedString), verified: verified)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == linearCollection && indexPath.row == 0 {
            if indexPath.row == 0 {
                self.moveToTop()
            }
        } else {
            let index = collectionView == linearCollection ? indexPath.row - 1 : indexPath.row
            self.showUser(withId: SearchStore.shared.users[index].id!)
        }
    }
    
}

class SearchHorizontalCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView : UIImageView!
    @IBOutlet weak var avatarNameLabel : UILabel!
    @IBOutlet weak var badgeImageView  : UIImageView!
    @IBOutlet weak var gradient: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gradient.image = R.image.common.gradient()
    }
    
    func setData(title: String, image: String, fill: Bool, hasBadge: Bool) {
        if fill {
            let url = URL(string: image)
            avatarImageView.kf.setImage(with: url, placeholder: R.image.common.avatarPlaceholder(), options: [.transition(.fade(0.35))], progressBlock: nil, completionHandler: nil)
        } else {
            gradient.image = UIImage()
            avatarImageView.image = R.image.search.fbtn()
            //      avatarImageView.image = R.image.search.plusButton()!.withRenderingMode(.alwaysTemplate)
            //      avatarImageView.tintColor = UIColor.white
        }
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        avatarImageView.layer.borderWidth = 2.0
        avatarNameLabel.text  = title
        if fill {
            avatarImageView.contentMode = .scaleAspectFill
        } else {
            avatarImageView.contentMode = .scaleAspectFit
        }
        if hasBadge == false {
            badgeImageView.isHidden = true
        } else {
            badgeImageView.isHidden = false
        }
    }
    
}


class SearchBigCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var verifiedImg: UIImageView!
    
    func setData(image: String, followers: String, verified: Bool) {
        let url = URL(string: image)
        avatarImageView.kf.setImage(with: url, placeholder: R.image.common.avatarPlaceholder(), options: [.transition(.fade(0.35))], progressBlock: nil, completionHandler: nil)
        
        followersCountLabel.text = followers
        
        if verified {
            verifiedImg.image = R.image.search.badge_on()
        } else {
            verifiedImg.image = R.image.search.badge_off()
        }
    }
    
}

//layout

protocol SearchLayoutDelegate: class {
    func scaleForItem(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndexPath indexPath: IndexPath) -> UInt
    func itemFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat
    func headerFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat
}

extension SearchLayoutDelegate {
    func scaleForItem(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, atIndexPath indexPath: IndexPath) -> UInt {
        return 1
    }
    
    func itemFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return fixedDimension
    }
    
    func headerFlexibleDimension(inCollectionView collectionView: UICollectionView, withLayout layout: UICollectionViewLayout, fixedDimension: CGFloat) -> CGFloat {
        return 0
    }
}

class SearchLayout: UICollectionViewLayout, SearchLayoutDelegate {
    var insertingIndexPaths = [IndexPath]()
    
    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        super.prepare(forCollectionViewUpdates: updateItems)
        
        insertingIndexPaths.removeAll()
        
        for update in updateItems {
            if let indexPath = update.indexPathAfterUpdate,
                update.updateAction == .insert {
                insertingIndexPaths.append(indexPath)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertingIndexPaths.removeAll()
    }
    
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        
        //if insertingIndexPaths.contains(itemIndexPath) {
        attributes?.alpha = 0.0
        attributes?.transform = CGAffineTransform(scaleX: 0, y: 0)
        //attributes?.transform = CGAffineTransform(translationX: 0, y: 500.0)
        
        //}
        
        return attributes
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    // User-configurable 'knobs'
    
    var scrollDirection: UICollectionViewScrollDirection = .vertical
    
    // Spacing between items
    var itemSpacing: CGFloat = 0
    
    // Prevent the user from giving an invalid fixedDivisionCount
    var fixedDivisionCount: UInt {
        get {
            return UInt(intFixedDivisionCount)
        }
        set {
            intFixedDivisionCount = newValue == 0 ? 1 : Int(newValue)
        }
    }
    
    weak var delegate: SearchLayoutDelegate?
    
    ///Animator
    var dynamicAnimator: UIDynamicAnimator?
    
    /// Backing variable for fixedDivisionCount, is an Int since indices don't like UInt
    private var intFixedDivisionCount = 1
    private var contentWidth: CGFloat = 0
    private var contentHeight: CGFloat = 0
    private var itemFixedDimension: CGFloat = 0
    private var itemFlexibleDimension: CGFloat = 0
    
    /// This represents a 2 dimensional array for each section, indicating whether each block in the grid is occupied
    /// It is grown dynamically as needed to fit every item into a grid
    private var sectionedItemGrid: [[[Bool]]] = []
    
    /// The cache built up during the `prepare` function
    private var itemAttributesCache: [UICollectionViewLayoutAttributes] = []
    
    /// The header cache built up during the `prepare` function
    private var headerAttributesCache: [UICollectionViewLayoutAttributes] = []
    
    /// A convenient tuple for working with items
    private typealias ItemFrame = (section: Int, flexibleIndex: Int, fixedIndex: Int, scale: Int)
    
    // MARK: - UICollectionView Layout
    
    override func prepare() {
        // On rotation, UICollectionView sometimes calls prepare without calling invalidateLayout
        guard itemAttributesCache.isEmpty, headerAttributesCache.isEmpty, let collectionView = collectionView else { return }
        
        let fixedDimension: CGFloat
        if scrollDirection == .vertical {
            fixedDimension = collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right)
            contentWidth = fixedDimension
        } else {
            fixedDimension = collectionView.frame.height - (collectionView.contentInset.top + collectionView.contentInset.bottom)
            contentHeight = fixedDimension
        }
        
        var additionalSectionSpacing: CGFloat = 0
        let headerFlexibleDimension = (delegate ?? self).headerFlexibleDimension(inCollectionView: collectionView, withLayout: self, fixedDimension: fixedDimension)
        
        itemFixedDimension = (fixedDimension - (CGFloat(fixedDivisionCount) * itemSpacing) + itemSpacing) / CGFloat(fixedDivisionCount)
        itemFlexibleDimension = (delegate ?? self).itemFlexibleDimension(inCollectionView: collectionView, withLayout: self, fixedDimension: itemFixedDimension)
        
        for section in 0 ..< collectionView.numberOfSections {
            let itemCount = collectionView.numberOfItems(inSection: section)
            
            // Calculate header attributes
            if headerFlexibleDimension > 0.0 && itemCount > 0 {
                if headerAttributesCache.isEmpty != true {
                    additionalSectionSpacing += itemSpacing
                }
                
                let frame: CGRect
                if scrollDirection == .vertical {
                    frame = CGRect(x: 0, y: additionalSectionSpacing, width: fixedDimension, height: headerFlexibleDimension)
                } else {
                    frame = CGRect(x: additionalSectionSpacing, y: 0, width: headerFlexibleDimension, height: fixedDimension)
                }
                let headerLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: IndexPath(item: 0, section: section))
                headerLayoutAttributes.frame = frame
                
                headerAttributesCache.append(headerLayoutAttributes)
                additionalSectionSpacing += headerFlexibleDimension
            }
            
            if headerFlexibleDimension > 0.0 || section > 0 {
                additionalSectionSpacing += itemSpacing
            }
            
            // Calculate item attributes
            let sectionOffset = additionalSectionSpacing
            sectionedItemGrid.append([])
            
            var flexibleIndex = 0, fixedIndex = 0
            for item in 0 ..< itemCount {
                if fixedIndex >= intFixedDivisionCount {
                    // Reached end of row in .vertical or column in .horizontal
                    fixedIndex = 0
                    flexibleIndex += 1
                }
                
                let itemIndexPath = IndexPath(item: item, section: section)
                let itemScale = indexableScale(forItemAt: itemIndexPath)
                let intendedFrame = ItemFrame(section, flexibleIndex, fixedIndex, itemScale)
                
                // Find a place for the item in the grid
                let (itemFrame, didFitInOriginalFrame) = nextAvailableFrame(startingAt: intendedFrame)
                
                reserveItemGrid(frame: itemFrame)
                let itemAttributes = layoutAttributes(for: itemIndexPath, at: itemFrame, with: sectionOffset)
                
                itemAttributesCache.append(itemAttributes)
                
                // Update flexible dimension
                if scrollDirection == .vertical {
                    if itemAttributes.frame.maxY > contentHeight {
                        contentHeight = itemAttributes.frame.maxY
                    }
                    if itemAttributes.frame.maxY > additionalSectionSpacing {
                        additionalSectionSpacing = itemAttributes.frame.maxY
                    }
                } else {
                    // .horizontal
                    if itemAttributes.frame.maxX > contentWidth {
                        contentWidth = itemAttributes.frame.maxX
                    }
                    if itemAttributes.frame.maxX > additionalSectionSpacing {
                        additionalSectionSpacing = itemAttributes.frame.maxX
                    }
                }
                
                if (didFitInOriginalFrame) {
                    fixedIndex += 1 + itemFrame.scale
                }
            }
        }
        sectionedItemGrid = [] // Only used during prepare, free up some memory
        
        if dynamicAnimator != nil {
            return
        }
        
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
        
        let contentSize = collectionViewContentSize
        
        if let items = super.layoutAttributesForElements(
            in: CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)) {
            
            for item in items {
                let spring = UIAttachmentBehavior(item: item, attachedToAnchor: item.center)
                spring.length = 0
                spring.damping = 0.5
                spring.frequency = 0.8
                dynamicAnimator?.addBehavior(spring)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let headerAttributes = headerAttributesCache.filter {
            $0.frame.intersects(rect)
        }
        let itemAttributes = itemAttributesCache.filter {
            $0.frame.intersects(rect)
        }
        
        return headerAttributes + itemAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributesCache.first {
            $0.indexPath == indexPath
        }
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard elementKind == UICollectionElementKindSectionHeader else { return nil }
        
        return headerAttributesCache.first {
            $0.indexPath == indexPath
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        if scrollDirection == .vertical, let oldWidth = collectionView?.bounds.width {
            return oldWidth != newBounds.width
        } else if scrollDirection == .horizontal, let oldHeight = collectionView?.bounds.height {
            return oldHeight != newBounds.height
        }
        
        return false
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        itemAttributesCache = []
        headerAttributesCache = []
        contentWidth = 0
        contentHeight = 0
    }
    
    // MARK: - Private
    
    private func indexableScale(forItemAt indexPath: IndexPath) -> Int {
        var itemScale = (delegate ?? self).scaleForItem(inCollectionView: collectionView!, withLayout: self, atIndexPath: indexPath)
        if itemScale > fixedDivisionCount {
            itemScale = fixedDivisionCount
        }
        return Int(itemScale - 1) // Using with indices, want 0-based
    }
    
    private func nextAvailableFrame(startingAt originalFrame: ItemFrame) -> (frame: ItemFrame, fitInOriginalFrame: Bool) {
        var flexibleIndex = originalFrame.flexibleIndex, fixedIndex = originalFrame.fixedIndex
        var newFrame = ItemFrame(originalFrame.section, flexibleIndex, fixedIndex, originalFrame.scale)
        while !isSpaceAvailable(for: newFrame) {
            fixedIndex += 1
            
            // Reached end of fixedIndex, restart on next flexibleIndex
            if fixedIndex + originalFrame.scale >= intFixedDivisionCount {
                fixedIndex = 0
                flexibleIndex += 1
            }
            
            newFrame = ItemFrame(originalFrame.section, flexibleIndex, fixedIndex, originalFrame.scale)
        }
        
        // Fits iff we never had to walk the grid to find a position
        return (newFrame, flexibleIndex == originalFrame.flexibleIndex && fixedIndex == originalFrame.fixedIndex)
    }
    
    /// Checks the grid from the origin to the origin + scale for occupied blocks
    private func isSpaceAvailable(for frame: ItemFrame) -> Bool {
        for flexibleIndex in frame.flexibleIndex ... frame.flexibleIndex + frame.scale {
            // Ensure we won't go off the end of the array
            while sectionedItemGrid[frame.section].count <= flexibleIndex {
                sectionedItemGrid[frame.section].append(Array(repeating: false, count: intFixedDivisionCount))
            }
            
            for fixedIndex in frame.fixedIndex ... frame.fixedIndex + frame.scale {
                if fixedIndex >= intFixedDivisionCount || sectionedItemGrid[frame.section][flexibleIndex][fixedIndex] {
                    return false
                }
            }
        }
        
        return true
    }
    
    private func reserveItemGrid(frame: ItemFrame) {
        for flexibleIndex in frame.flexibleIndex ... frame.flexibleIndex + frame.scale {
            for fixedIndex in frame.fixedIndex ... frame.fixedIndex + frame.scale {
                sectionedItemGrid[frame.section][flexibleIndex][fixedIndex] = true
            }
        }
    }
    
    private func layoutAttributes(for indexPath: IndexPath, at itemFrame: ItemFrame, with sectionOffset: CGFloat) -> UICollectionViewLayoutAttributes {
        let layoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        let fixedIndexOffset = CGFloat(itemFrame.fixedIndex) * (2 + itemFixedDimension)
        //    let fixedIndexOffset = CGFloat(itemFrame.fixedIndex) * (itemSpacing + itemFixedDimension)
        let longitudinalOffset = CGFloat(itemFrame.flexibleIndex) * (2 + itemFlexibleDimension) + sectionOffset
        let itemScaledTransverseDimension = itemFixedDimension + (CGFloat(itemFrame.scale) * (2 + itemFixedDimension))
        let itemScaledLongitudinalDimension = itemFlexibleDimension + (CGFloat(itemFrame.scale) * (2 + itemFlexibleDimension))
        
        if scrollDirection == .vertical {
            layoutAttributes.frame = CGRect(x: fixedIndexOffset, y: longitudinalOffset, width: itemScaledTransverseDimension, height: itemScaledLongitudinalDimension)
        } else {
            layoutAttributes.frame = CGRect(x: longitudinalOffset, y: fixedIndexOffset, width: itemScaledLongitudinalDimension, height: itemScaledTransverseDimension)
        }
        
        return layoutAttributes
    }
}
