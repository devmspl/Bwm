//
//  FavouritesController.swift
//  BWM
//
//  Created by obozhdi on 20/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import Kingfisher
import Flurry_iOS_SDK

class FavouritesController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.removeTabbarItemsText()
        self.title = "MY FAVORITES"
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Flurry.logEvent("FavoriteListScreen_show")
        self.tabBarController?.removeTabbarItemsText()
        unblockView()
        
        FavouritesRequest.fire { completed in
            if completed {
                self.tableView.reloadData()
                
                self.unblockView()
            }
        }
    }
    
}

extension FavouritesController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavouritesStore.shared.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouritesCell", for: indexPath) as! FavouritesCell
        
        let image = FavouritesStore.shared.users[indexPath.row].favoriteAccount?.avatarMedia?.thumbs?.x200
        let eth = FavouritesStore.shared.users[indexPath.row].favoriteAccount?.ethnicity?.name
        let cat = FavouritesStore.shared.users[indexPath.row].favoriteAccount?.category?.name
        
        cell.setData(image: image!, text: "\(cat ?? "") | \(eth ?? "")", indexPath: indexPath)
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let screen = R.storyboard.profileBig.alienInformationController() {
            screen.userId = "\((FavouritesStore.shared.users[indexPath.row].favoriteAccount?.id)!)"
            Flurry.logEvent("FavoriteListScreen_selectUser")
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
}

extension FavouritesController: FavouritesCellDelegate {
    
    func didRemoveFromFav(index: IndexPath) {
        blockView()
        Flurry.logEvent("FavoriteListScreen_removeUser")
        RemoveFromFavouritesRequest.fire(id: (FavouritesStore.shared.users[index.row].favoriteAccount?.id)!) { completed in
            if completed {
                FavouritesRequest.fire { completed in
                    if completed {
                        self.tableView.reloadData()
                        self.unblockView()
                    }
                }
            }
        }
    }
    
}

protocol FavouritesCellDelegate {
    func didRemoveFromFav(index: IndexPath)
}

class FavouritesCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var heartButton: UIButton!
    
    private var indexPath: IndexPath?
    
    var delegate: FavouritesCellDelegate?
    
    func setData(image: String, text: String, indexPath: IndexPath) {
        let url = URL(string: image)
        avatarImageView.kf.setImage(with: url, placeholder: R.image.common.avatarPlaceholder(), options: [.transition(.fade(0.35))], progressBlock: nil, completionHandler: nil)
        
        infoLabel.text = text
        
        self.indexPath = indexPath
    }
    
    @IBAction func tapRemove(_ sender: Any) {
        delegate?.didRemoveFromFav(index: self.indexPath!)
    }
}
