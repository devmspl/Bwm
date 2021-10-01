//
//  LocationManager.swift
//  BWM
//
//  Created by Serhii on 8/27/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import SwiftyUserDefaults
import CoreLocation

//MARK: - Manager
class LocationManager: NSObject {
    
    //MARK: - Variables
    private var locationManager = CLLocationManager()
    private var currentLocation: CLLocation?
    private var currentAuthorization: CLAuthorizationStatus = .notDetermined
    private var locationCallback: ((CLLocationCoordinate2D?)->Void)?
    
    private var timer: Timer?
    
    //MARK: - Init
    
    public static let shared = LocationManager()
    
    override init() {
        super.init()
        setupLocationManager()
        
        timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)
    }
    
    //MARK: - Private
    
    @objc private func runTimedCode() {
        if self.currentLocation != nil,
            Defaults[.token] != nil {
            self.locationManager.startUpdatingLocation()
            self.getLocation { (loc) in
                if Defaults[.liveTracking] == true,
                    let loc = loc {
                    UpdateLocationRequest.fire(coords: loc) { (success) in
                        if success {
                            print("updated location")
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Config
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.activityType = .other
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func updateSignificant() {
        //locationManager.startMonitoringSignificantLocationChanges()
    }
    
    func startReceivingSignificantLocationChanges() {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        if authorizationStatus != .authorizedAlways {
            // User has not authorized access to location information.
            return
        }
        
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
//             The service is not available.
            return
        }
        locationManager.startMonitoringSignificantLocationChanges()
    }

    
    //MARK: - Public interface
    public var location: CLLocation? {
        return currentLocation
    }
    
    public var authorization: CLAuthorizationStatus {
        return currentAuthorization
    }
    
    func sendLocationUpdate() {
        if let location = locationManager.location?.coordinate {
            self.sendLocationUpdate(location)
        }
    }
    
    private func sendLocationUpdate(_ coords: CLLocationCoordinate2D) {
        if self.currentLocation != nil,
            Defaults[.token] != nil {
            self.locationManager.startUpdatingLocation()
            if Defaults[.liveTracking] == true {
                UpdateLocationRequest.fire(coords: coords) { (success) in
                    if success {
                        print("updated location")
                    }
                }
            }
        }
    }
    
    public func getLocation(completion: @escaping (CLLocationCoordinate2D?)->()) {
        if currentLocation != nil {
            completion(currentLocation!.coordinate)
        }
        else {
            locationCallback = completion
            if CLLocationManager.authorizationStatus() == .notDetermined {
                self.requestAuthorization()
                locationManager.requestLocation()
            }
            else {
                locationManager.requestLocation()
            }
        }
        //
    }
    
    public func requestAuthorization() {
        locationManager.requestAlwaysAuthorization()
        //locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    // MARK : Responding to location events
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.first else {
            return
        }
        currentLocation = loc
        
        //self.sendLocationUpdate(loc.coordinate)
        if let callback = locationCallback {
            callback(loc.coordinate)
            locationCallback = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationCallback?(nil)
        locationCallback = nil
        print("CLLocationManagerDelegate : didFailWithError : \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
    }
    
    //MARK : Responding to Authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        currentAuthorization = status
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            IPLocationRequest.fire { (coordinates) in
                if let coordinates = coordinates {
                    self.currentLocation = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
                    if let callback = self.locationCallback {
                        callback(self.location!.coordinate)
                        self.locationCallback = nil
                    }
                }
            }
            break
        }
    }
    
}
