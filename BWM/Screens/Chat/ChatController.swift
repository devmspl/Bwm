//
//  ChatController.swift
//  BWM
//
//  Created by obozhdi on 20/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import InputBarAccessoryView
import Kingfisher
import QuartzCore

class ChatController: BaseViewController {
    
    var userId: Int!
    var userName: String?
    var avatarUrl: String?
    
    fileprivate var alienAccount: AlienAccount?
    
    fileprivate var chatRoom = ChatRoom()
    
    @IBOutlet private weak var tableData: UITableView!
    @IBOutlet private weak var labelName: UILabel!
    @IBOutlet private weak var userImage: UIImageView!
    
    let inputBar: InputBarAccessoryView = InputBarAccessoryView()
    private var keyboardManager = KeyboardManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chatRoom.delegate = self
        
        self.labelName.text = userName
        self.userImage.layer.cornerRadius = self.userImage.frame.size.width/2.0
        self.userImage.clipsToBounds = true
        if let urlstring = self.avatarUrl {
            let url = URL(string: urlstring)
            self.userImage.kf.setImage(with: url, placeholder: R.image.profile.photoPlaceholder(), options: [.transition(.fade(0.35))], progressBlock: nil, completionHandler: nil)
        }
        
        self.configureTable()
        self.configureInputView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.blockView()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        chatRoom.connect(withUserId: userId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @IBAction private func onBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private methods
    
    private func configureTable() {
        self.tableData.estimatedRowHeight = 100.0
        self.tableData.rowHeight = UITableViewAutomaticDimension
        self.tableData.keyboardDismissMode = .interactive
        self.tableData.tableFooterView = UIView()
        self.tableData.register(UINib(nibName: String(describing: ChatCell.self), bundle: nil), forCellReuseIdentifier: String(describing: ChatCell.self))
    }
    
    private func configureInputView() {
        inputBar.delegate = self
        inputBar.inputTextView.placeholder = "Write your message"
        
        view.addSubview(inputBar)
        
        inputBar.sendButton.isEnabled = false
        inputBar.sendButton.setTitleColor( UIColor(red: 235.0/255.0, green: 74.0/255.0, blue: 89.0/255.0, alpha: 1.0), for: .normal)
        let barHeight = self.inputBar.calculateIntrinsicContentSize().height
        self.tableData.contentInset.bottom = barHeight
        self.tableData.scrollIndicatorInsets.bottom = barHeight
        
        keyboardManager.bind(inputAccessoryView: inputBar)
        keyboardManager.bind(to: tableData)
        keyboardManager.on(event: .didChangeFrame) { [weak self] (notification) in
            let barHeight = self?.inputBar.bounds.height ?? 0
            self?.tableData.contentInset.bottom = barHeight + notification.endFrame.height
            self?.tableData.scrollIndicatorInsets.bottom = barHeight + notification.endFrame.height
            }.on(event: .didHide) { [weak self] _ in
                let barHeight = self?.inputBar.bounds.height ?? 0
                self?.tableData.contentInset.bottom = barHeight
                self?.tableData.scrollIndicatorInsets.bottom = barHeight
            }.on(event: .didShow) { [weak self](notification) in
                if let lastIndex = self?.chatRoom.messages.endIndex,
                    lastIndex > 0 {
                    let indexPath = IndexPath(row: lastIndex-1, section: 0)
                    self?.tableData.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
        }
    }
}

extension ChatController: ChatRoomDelegate {
    func chatRoom(_ chatRoom: ChatRoom, didReceiveMessagesAtIndexes indexes: [IndexPath]) {
        self.unblockView()
        self.tableData.insertRows(at: indexes, with: .automatic)
        if indexes.count > 0 {
            self.tableData.scrollToRow(at: indexes.last!, at: .top, animated: false)
        }
    }
    
    func chatRoomConnected(_ chatRoom: ChatRoom) {
        self.inputBar.sendButton.isEnabled = true
        if alienAccount == nil {
            AlienAccountRequest.fire(id: "\(userId!)") { [weak self] (account, _) in
                self?.alienAccount = account
                self?.labelName.text = account?.fullName
            }
        }
    }
}


extension ChatController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        self.chatRoom.sendMessage(text)
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
    }
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
    }
}

extension ChatController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            self.chatRoom.getOlderMessages()
        }
    }
}

extension ChatController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRoom.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatCell.self)) as! ChatCell
        cell.updateWithChatEvent(chatRoom.messages[indexPath.row])
        return cell
    }
    
    
}
