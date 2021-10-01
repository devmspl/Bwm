//
//  ChatRoom.swift
//  BWM
//
//  Created by Serhii on 8/25/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Starscream
import SwiftyUserDefaults

fileprivate let c_ItemsPerPage = 20

protocol ChatRoomDelegate: class {
    func chatRoom(_ chatRoom: ChatRoom, didReceiveMessagesAtIndexes indexes: [IndexPath])
    func chatRoomConnected(_ chatRoom: ChatRoom)
}

class ChatRoom {
    
    fileprivate var socket: WebSocket!
    fileprivate var userId: Int?
    
    fileprivate var pageReceived: Int?
    fileprivate var receivingMessages: Bool = false
    
    var isFetchedAll: Bool = false
    weak var delegate: ChatRoomDelegate?
    
    var messages: [ChatEvent] = []
    
    deinit {
        socket.delegate = nil
        socket.disconnect()
    }
    
    //MARK: - Public methods
    
    func connect(withUserId userId: Int) {
        self.userId = userId
        
        var request = URLRequest(url: URL(string: "ws://74.208.252.135/v1/conversations/\(userId)")!)
        //var request = URLRequest(url: URL(string: "ws://api.bwm.almet-systems.com/v1/conversations/\(userId)")!)
        request.timeoutInterval = 5
        request.setValue("Bearer " + Defaults[.token]!, forHTTPHeaderField: "Authorization")
        
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }
    
    func sendMessage(_ message: String) {
        let messageString = "{\"type\": \"message\", \"body\": \"\(message)\"}".replacingOccurrences(of: "\n", with: "\\n")
        socket.write(string: messageString)
    }
    
    func setMessageRead(messageId: Int) {
        let string = "{\"type\": \"read\", \"id\": \(messageId)}"
        socket.write(string: string)
    }
    
    func getOlderMessages() {
        if let page = self.pageReceived,
            !self.isFetchedAll {
            self.getMessagesOnPage(page+1)
        }
    }
    
    //MARK: - Private methods
    
    private func getMessagesOnPage(_ page: Int) {
        if let userId = self.userId,
            receivingMessages == false {
            receivingMessages = true
            GetLastMessagesRequest.fire(forUserId: userId, onPage: page, itemsCount: c_ItemsPerPage) { [page, weak self] (success, lastMessages) in
                self?.receivingMessages = false
                if success {
                    self?.pageReceived = page
                    if lastMessages!.count == 0 || lastMessages!.count < c_ItemsPerPage {
                        self?.isFetchedAll = true
                    }
                    
                    let sortedMessages = self?.sortedMessageArray(lastMessages)
                    self?.messages.insert(contentsOf: sortedMessages!, at: 0)
                    
                    let indexPaths = sortedMessages?.compactMap({ (newMessage) -> IndexPath? in
                        if let index = self?.messages.index(where: { $0.messageId == newMessage.messageId }) {
                            return IndexPath(row: index, section: 0)
                        }
                        return nil
                    })
                    if self != nil {
                        self!.messages = self!.sortedMessageArray(self!.messages)
                        if let msgId = self!.messages.last?.messageId {
                            self!.setMessageRead(messageId: msgId)
                        }
                        self!.delegate?.chatRoom(self!, didReceiveMessagesAtIndexes: indexPaths ?? [])
                    }
                }
            }
        }
    }
    
    func sortedMessageArray(_ array: [ChatEvent]?) -> [ChatEvent] {
        if array != nil {
            return array!.sorted(by: { (msg1, msg2) -> Bool in
                return msg1.createdAt < msg2.createdAt
            })
        }
        else {
            return []
        }
    }
}

extension ChatRoom: WebSocketDelegate {
    
    func websocketDidConnect(socket: WebSocketClient) {
        self.delegate?.chatRoomConnected(self)
        
        if pageReceived == nil {
            self.getMessagesOnPage(1)
        }
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        print(error.debugDescription)
        socket.connect()
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        guard let event = ChatEvent(JSONString: text) else { return }
        if event.type == .message {
            messages.append(event)
            let indexPath = IndexPath(row: self.messages.endIndex-1,
                                      section: 0)
            if let id = event.messageId {
                self.setMessageRead(messageId: id)
            }
            self.delegate?.chatRoom(self, didReceiveMessagesAtIndexes: [indexPath])
        }
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print(data)
    }
}
