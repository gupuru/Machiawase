//
//  CameraViewController.swift
//  Machiawase
//
//  Created by naru on 2017/03/04.
//  Copyright © 2017年 hazukit. All rights reserved.
//

import UIKit
import CoreLocation
import FirebaseDatabase

class CameraViewController: UIViewController, CLLocationManagerDelegate {
    
    var lm: CLLocationManager! = nil
    var heading: CLLocationDirection! = nil
    var currentLocation: MLocation! = nil
    var toLocation: MLocation! = nil // 後で配列にする
    private let ref = FIRDatabase.database().reference()
    private var firebaseName: String! = nil
    private var firebaseId: String! = nil
    private var peoples: [People] = []

    struct MLocation {
        public var latitude: CLLocationDegrees!
        public var longitude: CLLocationDegrees!
        public var altitude: CLLocationDistance!
    }
    
    struct People {
        var identifier: String
        var name: String
        var latitude: Double
        var longitude: Double
        var altitude: Double
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        
        let userDefaults = UserDefaults.standard
        firebaseName = userDefaults.string(forKey: "name")
        firebaseId = userDefaults.string(forKey: "firebaseId")
        
        ref.child("users").observe(.value, with: { snapshot in
            self.observeOtherLocation(snapshot: snapshot)
        })
        
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
    
        uploadMyLocation(fromLocation: fromLc)
        
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
    
    /** upload my location data to firebase */
    private func uploadMyLocation(fromLocation fromLc: MLocation) {
        if let name: String = self.firebaseName {
            if let id: String = self.firebaseId {
                let post = ["id": ["id" : id], "user": ["name": name], "location": ["longitude": fromLc.longitude, "latitude": fromLc.latitude, "altitude": fromLc.altitude]] as [String : Any]
                let childUpdates = ["/users/\(id)/": post]
                ref.updateChildValues(childUpdates)
            }
        }
    }
    
    /** observe firebase**/
    private func observeOtherLocation(snapshot: FIRDataSnapshot) {
        guard let dic = snapshot.value as? Dictionary<String, AnyObject> else {
            return
        }
        var peopleInfo: [People] = []
        for data in dic {
            var people: People = People.init(identifier: "", name: "", latitude: 0.0, longitude: 0.0, altitude: 0.0)
            
            let name = data.value["user"]
            let location = data.value["location"]
            let id = data.value["id"]
            if let userName: [String : String] = name as! [String : String]? {
                if let user: String = userName["name"] {
                    people.name = user
                }
            }
            if let userLocation: [String : Double] = location as! [String : Double]? {
                if let alt: Double = userLocation["altitude"] {
                    people.altitude = alt
                }
                if let lat: Double = userLocation["latitude"] {
                    people.latitude = lat
                }
                if let lon: Double = userLocation["longitude"] {
                    people.longitude = lon
                }
            }
            if let userId: [String : String] = id as! [String : String]? {
                if let identifier: String = userId["identifier"] {
                    people.identifier = identifier
                }
            }
            peopleInfo.append(people)
        }
        if !self.peoples.isEmpty {
            self.peoples.removeAll()
        }
        self.peoples = peopleInfo
    }
    
}
