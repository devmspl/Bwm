//
//  ChatCell.swift
//  BWM
//
//  Created by Serhii on 8/24/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet private weak var bubbleImage: UIImageView!
    @IBOutlet private weak var labelText: UILabel!
    @IBOutlet private weak var labelDate: UILabel!
    
    @IBOutlet private weak var constraintImageLeading: NSLayoutConstraint!
    @IBOutlet private weak var constraintImageTrailing: NSLayoutConstraint!
    @IBOutlet private weak var constraintDateHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        self.labelText.text = ""
        self.bubbleImage.image = nil
    }
    
    //MARK: - Public methods
    
    func updateWithChatEvent(_ event: ChatEvent) {
        self.labelText.text = event.body
        self.labelText.textColor = event.isSelf! ? .white : .black
        self.labelDate.text = !event.isSelf! ? Date(timeIntervalSince1970: event.createdAt).stringRepresentation(includeTime: true, extendedFormat: true) : ""
        self.constraintDateHeight.constant = !event.isSelf! ? 20.0 : 0.0
        self.updateImage(isSelf: event.isSelf!)
    }
    
    
    //MARK: - Private methods
    
    private func updateImage(isSelf: Bool) {
        guard let image = isSelf ? R.image.chat.chat_bubble_sent() : R.image.chat.chat_bubble_received() else { return }
        bubbleImage.image = image
            .resizableImage(withCapInsets:
                UIEdgeInsetsMake(17, 21, 17, 21),
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        
        if isSelf {
            self.bubbleImage.tintColor = UIColor(red: 235.0/255.0, green: 74.0/255.0, blue: 89.0/255.0, alpha: 1.0)
            self.constraintImageLeading.priority = .defaultLow
            self.constraintImageTrailing.priority = .defaultHigh
        }
        else {
            self.bubbleImage.tintColor = UIColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1.0)
            self.constraintImageLeading.priority = .defaultHigh
            self.constraintImageTrailing.priority = .defaultLow
        }
    }
}
