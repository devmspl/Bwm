//
//  MapController.swift
//  BWM
//
//  Created by obozhdi on 16/07/2018.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import Kingfisher
import CoreLocation
import Flurry_iOS_SDK

class BwmMarker: GMSMarker {
    var object: SearchObject?
}

class MapController: BaseViewController, GMSMapViewDelegate {
    
    var users: [SearchObject] = []
    
    @IBOutlet weak var mapView: GMSMapView!
    
    private var currentMarkerView: InfoView?
    
    var camera = GMSCameraPosition.camera(withLatitude: Double(LocationManager.shared.location?.coordinate.latitude ?? 0.0),
                                          longitude: Double(LocationManager.shared.location?.coordinate.longitude ?? 0.0),
                                          zoom: 10.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.isMyLocationEnabled = true
        self.mapView.camera = camera
        self.addMarkers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setUsers(_ users: [SearchObject]) {
        self.users = users
        self.addMarkers()
    }
    
    private func addMarkers() {
        self.mapView.clear()
        //var i = 0
        for user in self.users {
            //i += 1
            //if i == 80 { break }
            let object = user
            var latitude: Double? = nil
            var longitude: Double? = nil
            
            if let point = object.point,
                let lat = point.latitude,
                let lon = point.longitude {
                latitude = Double(lat)
                longitude = Double(lon)
            }
            else if let location = object.locations?.first(where: { (loc) -> Bool in
                return loc.isSelected == true
            }), let lat = location.latitude,
                let lon = location.longitude {
                latitude = Double(lat)
                longitude = Double(lon)
            }
            
            if let latitude = latitude,
                let longitude = longitude {
                let marker = BwmMarker(position: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                
                marker.object = object
                marker.tracksInfoWindowChanges = true
                if object.isPro! {
                    let icView = ProIconView(frame: CGRect(x: 0, y: 0, width: 45, height: 56))
                    icView.setData(image: (object.avatarMedia?.thumbs?.x100)!)
                    
                    marker.iconView = icView
                } else {
                    marker.icon = UIImage(named: "Common/markerIcon")//iconView = NoProIconView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
                }
                
                marker.map = self.mapView
            }
        }
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        Flurry.logEvent("FrontPage_map_selectUser")
        if let screen = R.storyboard.profileBig.alienInformationController() {
            screen.userId = "\(((marker as! BwmMarker).object?.id)!)"
            self.navigationController?.pushViewController(screen, animated: true)
        }
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        currentMarkerView = InfoView(frame: CGRect.init(x: 0, y: 0, width: 180, height: 100))
        
        if let nm = marker as? BwmMarker {
            let obj = nm.object
            
            currentMarkerView?.setData(followers: obj?.followerCount, image: obj?.avatarMedia?.thumbs?.x100, info: obj?.category?.name, verified: obj?.isVerified, id: obj?.id)
        }
        
        return currentMarkerView
    }
}

class NoProIconView: UIView {
    
    private var pinImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        
        pinImageView.contentMode = .scaleAspectFit
        pinImageView.image = UIImage(named: "Common/markerIcon")
        
        addSubview(pinImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pinImageView.frame = bounds
    }
    
}

class ProIconView: UIView {
    
    private var avatarImageView = UIImageView()
    private var pinImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        backgroundColor = .clear
        
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.tintColor = .white
        pinImageView.contentMode = .scaleAspectFit
        pinImageView.image = UIImage(named: "Common/proMarkerIcon")
        
        addSubview(pinImageView)
        addSubview(avatarImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pinImageView.frame = bounds
        
        avatarImageView.layer.cornerRadius = 18.5
        avatarImageView.frame = CGRect(x: 4, y: 4.5, width: 37, height: 37)
    }
    
    func setData(image: String) {
        let url = URL(string: image)
        
        avatarImageView.kf.setImage(with: url, placeholder: R.image.common.avatarPlaceholder(), options:nil, progressBlock: nil, completionHandler: nil)
    }
    
}

class InfoView: UIView {
    
    private var grayUnder      = UIView()
    private var followerslabel = UILabel()
    private var verifiedIcon   = UIImageView()
    
    private var gradientUnder = UIImageView()
    var avatar        = UIImageView()
    private var enclosure     = UIImageView()
    private var infoLabel     = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup() {
        backgroundColor = .white
        clipsToBounds = true
        
        grayUnder.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.6)
        
        followerslabel.textColor = .white
        followerslabel.font      = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        verifiedIcon.image       = UIImage(named : "Search/badge_off")
        verifiedIcon.contentMode = .scaleAspectFit
        
        addSubview(grayUnder)
        grayUnder.addSubview(followerslabel)
        grayUnder.addSubview(verifiedIcon)
        
        gradientUnder.image         = UIImage(named : "Common/gradient")
        gradientUnder.contentMode   = .scaleAspectFill
        gradientUnder.clipsToBounds = true
        
        avatar.image           = nil//UIImage(named : "Common/avatarPlaceholder")
        avatar.contentMode     = .scaleAspectFill
        avatar.clipsToBounds   = true
        avatar.backgroundColor = .white
        
        infoLabel.textColor          = .gray
        infoLabel.font               = UIFont.systemFont(ofSize: 14, weight: .medium)
        infoLabel.minimumScaleFactor = 0.5
        infoLabel.numberOfLines = 0
        
        addSubview(gradientUnder)
        addSubview(avatar)
        addSubview(infoLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientUnder.layer.cornerRadius = 28
        avatar.layer.cornerRadius = 26
        
        gradientUnder.frame = CGRect(x: 8, y: 8, width: 56, height: 56)
        avatar.frame = CGRect(x: 10, y: 10, width: 52, height: 52)
        
        grayUnder.frame = CGRect(x: 0, y: bounds.height - 28, width: bounds.width, height: 28)
        followerslabel.frame = CGRect(x: 8, y: 0, width: 130, height: 28)
        verifiedIcon.frame = CGRect(x: bounds.width - 28, y: 2, width: 24, height: 24)
        
        infoLabel.frame = CGRect(x: gradientUnder.frame.maxX + 8, y: 8, width: bounds.width - 24 - 56, height: 56)
        
        layer.cornerRadius = 6.0
    }
    
    func setData(followers: Int?, image: String?, info: String?, verified: Bool?, id: Int?) {
        followerslabel.text = "Followers:   \(followers?.roundedString ?? "")"
        
        if verified == true {
            verifiedIcon.image = UIImage(named: "Search/badge_on")
        } else {
            verifiedIcon.image = UIImage(named: "Search/badge_off")
        }
        if let image = image {
            let url = URL(string: image)
            avatar.kf.setImage(with: url, placeholder:nil, options:nil, progressBlock: nil, completionHandler: nil)
        }
        
        infoLabel.text = info ?? ""
    }
    
}
