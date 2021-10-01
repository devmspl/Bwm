//
//  ChatListCell.swift
//  BWM
//
//  Created by Serhii on 8/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import QuartzCore
import Kingfisher

class ChatListCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelText: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    
    @IBOutlet private weak var imageIsRead: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellImage.layer.cornerRadius = cellImage.frame.size.width / 2.0
    }
    
    override func prepareForReuse() {
        cellImage.image = nil
        labelText.text = ""
        labelDate.text = ""
        labelName.text = ""
    }
    
    func customizeForChat(_ chat: ChatListObject) {
        if let urlstring = chat.account.avatarMedia?.thumbs?.x200 {
            let url = URL(string: urlstring)
            self.cellImage.kf.setImage(with: url, placeholder: R.image.profile.photoPlaceholder(), options: [.transition(.fade(0.35))], progressBlock: nil, completionHandler: nil)
        }
        
        self.labelName.text = chat.account.fullName
        self.imageIsRead.isHidden = chat.latestMessage?.isRead ?? false
        if let created = chat.latestMessage?.createdAt {
            self.labelDate.text = Date(timeIntervalSince1970: created).stringRepresentation(includeTime: false, extendedFormat: false)
        }
        
        if let lastMessage = chat.latestMessage {
            self.labelText.text = lastMessage.body
        }
    }
    
    static func cellHeight() -> CGFloat {
        return 81.0
    }
}
