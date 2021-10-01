//
//  SelectLocationController.swift
//  BWM
//
//  Created by Serhii on 10/17/18.
//  Copyright © 2018 Almet Systems. All rights reserved.
//

import UIKit
import GoogleMaps
import Flurry_iOS_SDK

fileprivate extension CLPlacemark {
    func toString() -> String {
        return "\(self.subThoroughfare ?? "") \(self.thoroughfare ?? ""), \(self.locality ?? ""), \(self.administrativeArea ?? "")"
    }
}

protocol SelectLocationControllerDelegate: class {
    func didSelectLocation(_ location: LocationModel)
    func didRemoveLocation()
}

class SelectLocationController: UIViewController {

    weak var delegate: SelectLocationControllerDelegate?
    
    var selectionEnabled: Bool = true
    var locationToShow: LocationModel?
    var canManageSelectedLocation: Bool = false
    var canShowRoute: Bool = false
    
    @IBOutlet fileprivate weak var viewMap: GMSMapView!
    @IBOutlet fileprivate weak var labelAddress: UILabel!
    @IBOutlet fileprivate weak var buttonAction: UIButton!
    @IBOutlet fileprivate weak var constraintButtonHeight: NSLayoutConstraint!
    @IBOutlet fileprivate weak var constraintManageViewHeight: NSLayoutConstraint!
    
    fileprivate var camera: GMSCameraPosition?
    fileprivate var selectedPlace: CLPlacemark?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewMap.delegate = self
        viewMap.isMyLocationEnabled = true
        viewMap.settings.myLocationButton = true
        
        Flurry.logEvent("SelectLocationScreen_show")
        
        if let location = self.locationToShow {
            let coords = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            self.setMarkerAtPosition(coords)
            self.labelAddress.text = location.locationName
            self.centerCamera(atCoordinate: coords)
            if canShowRoute {
                self.buttonAction.setTitle("SHOW ROUTE", for: .normal)
            }
            else {
                self.constraintButtonHeight.constant = 0.0
            }
        }
        else if let location = LocationManager.shared.location {
            self.centerCamera(atCoordinate: location.coordinate)
        }
        
        self.constraintManageViewHeight.constant = canManageSelectedLocation ? 80.0 : 0.0
    }
    
    //MARK: - Actions
    
    @IBAction private func onSelectButton() {
        if canShowRoute {
            Flurry.logEvent("SelectLocationScreen_showRoute")
            guard let currentCoords = LocationManager.shared.location?.coordinate,
            let destLat = locationToShow?.latitude,
            let destLon = locationToShow?.longitude else { return }
            if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {
                guard let url = URL(string: "comgooglemaps://?saddr=\(currentCoords.latitude),\(currentCoords.longitude)&daddr=\(destLat)),\(destLon)") else { return }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        else {
            Flurry.logEvent("SelectLocationScreen_select")
            if let place = selectedPlace,
                let coordinates = place.location?.coordinate {
                let model = LocationModel()
                model.locationName = place.toString()
                model.latitude = coordinates.latitude
                model.longitude = coordinates.longitude
                self.delegate?.didSelectLocation(model)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction private func onSetDefaultButton() {
        if let id = self.locationToShow?.locationId {
            Flurry.logEvent("SelectLocationScreen_setDefault")
            SelectLocationRequest.fire(locationId: id) { (success) in
                if success {
                    self.delegate?.didRemoveLocation()
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction private func onRemoveButton() {
        if let id = self.locationToShow?.locationId {
            Flurry.logEvent("SelectLocationScreen_remove")
            DeleteLocationRequest.fire(id: id) { (success) in
                if success {
                    self.delegate?.didRemoveLocation()
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK: - Private methods
    
    private func centerCamera(atCoordinate coordinate: CLLocationCoordinate2D) {
        camera = GMSCameraPosition.camera(withLatitude: coordinate.latitude,
                                          longitude: coordinate.longitude,
                                          zoom: 15.0)
        viewMap.camera = camera!
    }
    
    func addressForCoordinate(_ coordinate: CLLocationCoordinate2D, completionHandler: @escaping (CLPlacemark?)
        -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude),
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                completionHandler(firstLocation)
                                            }
                                            else {
                                                completionHandler(nil)
                                            }
        })
    }
    
    func getPlaces(forAddress addressString : String,
                        completionHandler: @escaping([CLPlacemark]?, Error?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                completionHandler(placemarks, nil)
            }
            
            completionHandler(nil, error)
        }
    }
    
    func setMarkerAtPosition(_ coordinate: CLLocationCoordinate2D) {
        self.viewMap.clear()
        
        let marker = BwmMarker(position: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude))
        marker.iconView = NoProIconView(frame: CGRect(x: 0, y: 0, width: 25, height: 30))
        marker.map = self.viewMap
    }
}

extension SelectLocationController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if self.selectionEnabled {
            self.addressForCoordinate(coordinate) { [coordinate] (placemark) in
                if let placemark = placemark {
                    self.selectedPlace = placemark
                    self.labelAddress.text = placemark.toString()
                    self.setMarkerAtPosition(coordinate)
                    self.centerCamera(atCoordinate: coordinate)
                }
            }
        }
    }
}
