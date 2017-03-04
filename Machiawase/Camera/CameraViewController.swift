//
//  CameraViewController.swift
//  Machiawase
//
//  Created by naru on 2017/03/04.
//  Copyright © 2017年 hazukit. All rights reserved.
//

import UIKit
import CoreLocation

class CameraViewController: UIViewController, CLLocationManagerDelegate {
    
    var lm: CLLocationManager! = nil
    var heading: CLLocationDirection! = nil
    var currentLocation: MLocation! = nil
    var toLocation: MLocation! = nil // 後で配列にする
    
    struct MLocation {
        public var latitude: CLLocationDegrees!
        public var longitude: CLLocationDegrees!
        public var altitude: CLLocationDistance!
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        self.view.addSubview(self.captureStillImageView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toLocation = MLocation()
        toLocation.latitude = 35.698353
        toLocation.longitude = 139.773114
        toLocation.altitude = 0
        
        self.captureStillImageView.setupCamera()
        self.captureStillImageView.startSession()
        if CLLocationManager.locationServicesEnabled() {
            lm = CLLocationManager()
            lm.delegate = self
            lm.requestAlwaysAuthorization()
            lm.desiredAccuracy = kCLLocationAccuracyBest
            lm.distanceFilter = 300
            lm.startUpdatingLocation()
            lm.startUpdatingHeading();
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.captureStillImageView.stopSession()
        lm.stopUpdatingHeading();
        lm.stopUpdatingLocation();
    }
    
    // MARK: Elements
    
    lazy var peopleManager: PeopleManager = PeopleManager(with: self.view)
    
    lazy var captureStillImageView: CaptureStillImageView = {
        let view: CaptureStillImageView = CaptureStillImageView(frame: self.view.bounds)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return view
    }()
    
    // MARK: -
    // MARK: private methods
    private func displayPoint(heading hd: CLLocationDirection!, fromLocation fromLc: MLocation!,  toLocation toLc: MLocation!) {
        if (hd == nil || fromLc == nil || toLc == nil) {
            return
        }
        
        /*
        let latitude = (toLc.latitude - fromLc.latitude)
        let longitude = (toLc.longitude - fromLc.longitude)
        let altitude = (toLc.altitude - fromLc.altitude)
        
        print("point hd:", hd)
        */
    }
    
    private func displayPoint(heading hd: CLLocationDirection!, fromLocation fromLc: MLocation!,  toLocations toLcs: [MLocation]!) {
        
    }
    
    
    // MARK: -
    // MARK: CLLocationManagerDelegate methods
    /** 位置情報取得成功時 */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else {
            return
        }
        currentLocation = MLocation()
        currentLocation.latitude = newLocation.coordinate.latitude
        currentLocation.longitude = newLocation.coordinate.longitude
        currentLocation.altitude = newLocation.altitude
        
        displayPoint(heading: heading, fromLocation: currentLocation, toLocation: toLocation)
    }
    
    /** 方向取得成功時 */
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        heading = ((newHeading.trueHeading > 0) ? newHeading.trueHeading : newHeading.magneticHeading);
        
//        heading = newHeading
        displayPoint(heading: heading, fromLocation: currentLocation, toLocation: toLocation)
    }
    
    /** 位置情報取得失敗時 */
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status:   CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            lm.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        }
    }
}
