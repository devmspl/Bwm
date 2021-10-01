//
//  StartVideoController.swift
//  BWM
//
//  Created by Serhii on 9/16/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import AVKit
import QuartzCore
import SwiftyUserDefaults
import Kingfisher
import Flurry_iOS_SDK

class StartVideoController: UIViewController {

    @IBOutlet private weak var viewVideo: UIView!
    @IBOutlet private weak var viewUser: UIView!
    @IBOutlet private weak var viewAvatar: UIView!
    @IBOutlet private weak var imageAvatar: UIImageView!
    
    var videoUrl: String!
    var userAvatarUrl: String?
    var userId: Int!
    
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupVideoLayer()
        
        if let urlString = userAvatarUrl,
            let url = URL(string: urlString){
            imageAvatar.kf.setImage(with: url, placeholder: nil, options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        let videoTap = UITapGestureRecognizer(target: self, action: #selector(onVideoTap))
        viewVideo.addGestureRecognizer(videoTap)
        
        let userTap = UITapGestureRecognizer(target: self, action: #selector(onUserTap))
        viewAvatar.addGestureRecognizer(userTap)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        playerLayer.frame = viewVideo.bounds
    }
    
    //MARK: - Actions
    @objc private func onVideoTap() {
        if player.volume < 1.0 {
            player.volume = 1.0
        }
        else {
            player.volume = 0.0
        }
    }
    
    @objc private func onUserTap() {
        Store.shared.userIdFromVideo = userId
        stopVideo()
    }
    
    @IBAction private func onButtonSkip() {
        Flurry.logEvent("StartVideo_skip")
        stopVideo()
    }
    
    //MARK: - Private methods
    
    private func setupVideoLayer() {
        if let url = URL(string: videoUrl) {
            player = AVPlayer(url: url)
            player.volume = 0.0
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.videoGravity = .resizeAspectFill
            playerLayer.frame = viewVideo.bounds
            viewVideo.layer.addSublayer(playerLayer)
            
            NotificationCenter.default.addObserver(self,
                                                   selector:#selector(stopVideo),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem)
            player.play()
            Flurry.logEvent("StartVideo_play")
        }
    }
    
    @objc private func stopVideo() {
        NotificationCenter.default.removeObserver(self)
        player.pause()
        player.replaceCurrentItem(with: nil)
        if Defaults[.token] != nil {
            guard let window = UIApplication.shared.delegate?.window else { return }
            window?.rootViewController = Storyboards.Main.instantiateInitialViewController()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
}
