//
//  ChatListController.swift
//  BWM
//
//  Created by Serhii on 8/23/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import Flurry_iOS_SDK

class ChatListController: BaseViewController {

    var selectedChat: ChatListObject?
    
    @IBOutlet private weak var tableData: UITableView!
    
    var conversations: [ChatListObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Flurry.logEvent("ChatListScreen_show")
        
        self.tabBarController?.removeTabbarItemsText()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.blockView()
        NotificationCenter.default.addObserver(self, selector: #selector(onNewMessage), name: NSNotification.Name(Constants.Notification.newMessage), object: nil)
        self.tabBarController?.updateChatIcon(messageCount: 0)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ChatListRequest.fire { [weak self] (success, conversations) in
            self?.unblockView()
            self?.conversations = conversations
            if let message = Store.shared.receivedMessagePushNotification {
                for chat in conversations! {
                    if chat.account.id == message.accountId {
                        self?.selectedChat = chat
                        break
                    }
                }
                Store.shared.receivedMessagePushNotification = nil
                if self?.selectedChat != nil {
                    self?.performSegue(withIdentifier: R.segue.chatListController.chatController.identifier, sender: self)
                }
            }
            else if let chatId = Store.shared.deepLinkChatUserId {
                for chat in conversations! {
                    if chat.account.id == chatId {
                        self?.selectedChat = chat
                        break
                    }
                }
                Store.shared.deepLinkChatUserId = nil
                if self?.selectedChat != nil {
                    self?.performSegue(withIdentifier: R.segue.chatListController.chatController.identifier, sender: self)
                }
            }
            self?.tableData.reloadData()
        }
    }
    
    //MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == R.segue.chatListController.chatController.identifier {
            return selectedChat != nil
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let chat = selectedChat,
            segue.identifier == R.segue.chatListController.chatController.identifier {
            Flurry.logEvent("ChatListScreen_selectChat")
            let screen = segue.destination as! ChatController
            screen.userId = chat.account.id
            screen.userName = chat.account.fullName
            screen.avatarUrl = chat.account.avatarMedia?.thumbs?.x200
            screen.hidesBottomBarWhenPushed = true
        }
    }
    
    //MARK: - Private methods
    
    @objc private func onNewMessage() {
        ChatListRequest.fire { [weak self] (success, conversations) in
            self?.conversations = conversations
            self?.tableData.reloadData()
        }
    }
    
    private func showBlockAlert(forUserId userId: Int) {
        let alertController = UIAlertController(title: "", message: "Are you sure you want to block user?", preferredStyle: .alert)
        Flurry.logEvent("ChatListScreen_blockUser")
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [userId] (action) in
            BlockUserRequest.fire(withUserId: userId, completion: { (success) in
                
            })
        }))
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ChatListController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedChat = self.conversations?[indexPath.row]
        
        return indexPath
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction  = UITableViewRowAction(style: .normal, title: "Delete") { [weak self] (rowAction, indexPath) in
            if let userId = self?.conversations?[indexPath.row].account.id {
                RemoveChatConversationRequest.fire(withUserId: userId, completion: { (success) in
                    if success {
                        Flurry.logEvent("ChatListScreen_deleteChat")
                        self?.conversations?.remove(at: indexPath.row)
                        self?.tableData.deleteRows(at: [indexPath], with: .automatic)
                    }
                })
            }
        }
        let blockAction  = UITableViewRowAction(style: .default, title: "Block") { [weak self] (rowAction, indexPath) in
            if let userId = self?.conversations?[indexPath.row].account.id {
                self?.showBlockAlert(forUserId: userId)
            }
        }
        
        deleteAction.backgroundColor = UIColor(236, 73, 89, 1.0)
        blockAction.backgroundColor = UIColor(236, 73, 89, 1.0)
        
        return [blockAction,deleteAction]
    }
}

extension ChatListController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ChatListCell.cellHeight()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ChatListCell.self)) as! ChatListCell
        if let chat = conversations?[indexPath.row] {
            cell.customizeForChat(chat)
        }
        
        return cell
    }
    
    
}
