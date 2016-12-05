//
//  RunTrackerViewController.swift
//  Pace
//
//  Created by Angel Lo on 11/14/16.
//  Copyright © 2016 Angel. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import CoreLocation
import HealthKit

class RunTrackerViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    
    let clientID = "7884d212f6ef45b5b4691688644f1217"
    let callURL = "pace://returnAfterLogin"
    let tokenSwapURL = "http://localhost:1234/swap"
    let tokenRefreshServiceURL = "http://localhost:1234/refresh"
    var playlist: [AnyObject] = []
    let auth: SPTAuth = SPTAuth.defaultInstance()
    

    var player: SPTAudioStreamingController?
    let homeVC:HomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as! HomeViewController
    
    // MARK: Properties
    @IBOutlet weak var songTitleLbl: UITextView!
    @IBOutlet weak var artistLbl: UITextView!
    @IBOutlet weak var distanceRunLbl: UITextView!
    @IBOutlet weak var timeElapsedLbl: UITextView!
    @IBOutlet weak var targetPaceLbl: UITextView!
    @IBOutlet weak var endRunBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginToPlayer()
        loadSongData()
        
        // Set font
        distanceRunLbl.font = UIFont.boldSystemFontOfSize(85)
        timeElapsedLbl.font = UIFont(name: "Avenir", size: 17)
        targetPaceLbl.font = UIFont(name: "Avenir", size: 17)
        songTitleLbl.font = UIFont(name: "Avenir", size: 11)
        artistLbl.font = UIFont(name: "Avenir", size: 11)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func loadSongData() {
        let song = playlist[0]
        
        // Populate song label
        songTitleLbl.text = song["title"] as? String
        
        // Populate artist label
        if (song["artists"] != nil) {
            let artists = song["artists"] as! NSArray
            
            // Handle multiple artists
            if artists.count < 1 {
                artistLbl.text = artists[0] as! String
            } else {
                let artist = artists[0] as! String
                let features = artists.componentsJoinedByString(", ")
                artistLbl.text = "\(artist) feat. \(features)"
            }
        }
    }
    
    // MARK: Actions
    
    // End Run Button
    @IBAction func endRun(sender: AnyObject) {
        SaveRun()
        self.performSegueWithIdentifier("endRunSegue", sender: self)
    }
    
    // MARK: Prepare Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "endRunSegue"{
            let vc = segue.destinationViewController as! RunSummaryViewController
            vc.run = currentRun
        }
    }
    
    // MARK: Variables
    var targetPace: String!
    var seconds = 0.0
    var distance = 0.0
    var currentRun: NSManagedObject!
    var managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    lazy var locations = [CLLocation]()
    lazy var timer = NSTimer()
    
    // MARK: Location Manager Properties
    lazy var locationManager: CLLocationManager = { //lazy establishes variable when first needed
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self //_locationManager delegate
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest //_locationManager properties
        _locationManager.activityType = .Fitness
        _locationManager.distanceFilter = 10.0
        return _locationManager //locationManager = _locationManager
    }()
    
    func startLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        locationManager.startUpdatingLocation()
    }

    // MARK: Entering the View
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.requestAlwaysAuthorization()
        
        seconds = 0.0
        distance = 0.0
        locations.removeAll(keepCapacity: false)
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(RunTrackerViewController.eachSecond(_:)), userInfo: nil, repeats: true)
        startLocationUpdates()
    }
    
    // MARK: Exiting the View
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()

    }
    // MARK: Timer Method
    func eachSecond(timer: NSTimer) {
        seconds += 1
        let secondsQuantity = HKQuantity(unit: HKUnit.secondUnit(), doubleValue: seconds)
        timeElapsedLbl.text = secondsQuantity.description
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        distanceRunLbl.text = distanceQuantity.description
        
        // Set font
        distanceRunLbl.font = UIFont.boldSystemFontOfSize(85)
        timeElapsedLbl.font = UIFont(name: "Avenir", size: 17)
        timeElapsedLbl.textAlignment = .Center
        distanceRunLbl.textAlignment = .Center
    }
    
    // MARK: Save Method
    func SaveRun() {
        timer.invalidate()
        
        let savedRun = NSEntityDescription.insertNewObjectForEntityForName("Run", inManagedObjectContext: managedContext)
        savedRun.setValue(distance, forKey: "distance")
        savedRun.setValue(seconds, forKey: "duration")
        savedRun.setValue(NSDate(), forKey: "timestamp")
        
        currentRun = savedRun
        
        for location in locations {
            let savedLocation = NSEntityDescription.insertNewObjectForEntityForName("Location", inManagedObjectContext: managedContext)
            
            savedLocation.setValue(location.timestamp, forKey: "timestamp")
            savedLocation.setValue(location.coordinate.latitude, forKey: "latitude")
            savedLocation.setValue(location.coordinate.longitude, forKey: "longitude")
            
            savedRun.mutableSetValueForKey("locations").addObject(savedLocation)
        }
        
        do {
            try managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    // MARK: Audio
    func startNextSong() {
        let uri = playlist[0]["uri"] as! String
        
        player!.playSpotifyURI(uri, startingWithIndex: 0, startingWithPosition: 0) { (error: NSError?) in
            if error != nil {
                print("Unable to play song")
            }
        }
        
    }
    
    func loginToPlayer() {

        if player == nil {
            player = SPTAudioStreamingController.sharedInstance()
            
            do {
                try player?.startWithClientId(clientID)
            } catch {
                print("Player could not be initialized")
            }
        }
        player?.delegate = self
        player?.playbackDelegate = self
        player?.loginWithAccessToken(auth.session.accessToken)
        
    }
    
    func audioStreamingDidLogin(audioStreaming: SPTAudioStreamingController!) {
        startNextSong()
        print("Successful login!")
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didReceiveError error: NSError!) {
        print(error)
    }
    
}

// MARK: - CLLocationManagerDelegate
extension RunTrackerViewController: CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("recieved location")
        for location in locations as [CLLocation]{ //locations contain current locations outputted by the location manager (usually 1 location)
            if location.horizontalAccuracy < 20 { //consider outputting location if accurage enough
                if self.locations.count > 0 { //self.locations contain all locations in run
                    distance += location.distanceFromLocation(self.locations.last!) //add to total distance ran
                }
                self.locations.append(location) //add outputting location to self.locations
            }
        }
    }
}