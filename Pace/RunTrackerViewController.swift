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
    
    
    // MARK: Actions
    // Saving the Run
    @IBAction func endRun(sender: AnyObject) {
        let savedRun = NSEntityDescription.insertNewObjectForEntityForName("Run", inManagedObjectContext: managedObjectContext)
        savedRun.setValue(NSDate(), forKey: "date")
        savedRun.setValue(Double(distance), forKey: "distance")
        savedRun.setValue(Double(targetPace), forKey: "pace")
        savedRun.setValue(Double(seconds), forKey: "time")
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    // MARK: Variables
    var targetPace: String!
    var seconds = 0.0
    var distance = 0.0
    
    lazy var locations = [CLLocation]()
    lazy var timer = NSTimer()
    
    // MARK: Location Manager Properties
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 10.0
        return _locationManager
    }()
    
    func startLocationUpdates() {
        // Here, the location manager will be lazily instantiated
        locationManager.startUpdatingLocation()
    }

    // MARK: Entering the View
    override func viewWillAppear(animated: Bool) {
        locationManager.requestAlwaysAuthorization() // authorize core location
        
        // initialize fields and timer
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
        
        // MARK: Set font
        distanceRunLbl.font = UIFont.boldSystemFontOfSize(120)
        timeElapsedLbl.font = UIFont(name: "Avenir", size: 17)
        timeElapsedLbl.textAlignment = .Center
        distanceRunLbl.textAlignment = .Center
//        targetPaceLbl.text = targetPace + " minutes per mile"
    }

    
    //MARK: Spotify Player
    override func viewDidLoad() {
        super.viewDidLoad()
        loginToPlayer()
        // MARK: Set font
        distanceRunLbl.font = UIFont.boldSystemFontOfSize(120)
        timeElapsedLbl.font = UIFont(name: "Avenir", size: 17)
        targetPaceLbl.font = UIFont(name: "Avenir", size: 17)
        songTitleLbl.font = UIFont(name: "Avenir", size: 11)
        artistLbl.font = UIFont(name: "Avenir", size: 11)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startNextSong() {
        let uri = self.playlist[0]["uri"] as! String
        
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
    

    func searchForSong() {

//        var searchResult = NSURL(string: "http://www.google.com")
//        
//        //testing how the SPTListPage works 
//        //var searchResultPage: SPTListPage
//        
//        do{
//            //this searches for the track (using QueryTypeTrack) and outputs and SPTList but I dont understand how to query the SPT list
//            //Also tried assigning searhResultPage to this, but I get an "Ambiguous Reference" error
//            try searchResult = SPTSearch.createRequestForSearchWithQuery("Fake Tales of San Francisco", queryType: SPTSearchQueryType.QueryTypeTrack, offset:1, accessToken: auth.session.accessToken).URL!
//        } catch {
//            print("Not a valid search term")
//        }
//   
//        UIApplication.sharedApplication().openURL(searchResult!)

    }
    
    func audioStreamingDidLogin(audioStreaming: SPTAudioStreamingController!) {
//        searchForSong()
        startNextSong()
        print("Successful login!")
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didReceiveError error: NSError!) {
        print(error)
    }
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "endRunSegue"{
            let nextScene = segue.destinationViewController as? RunSummaryViewController
            nextScene!.seconds = seconds
            nextScene!.distance = distance
            nextScene!.targetPace = Double(targetPace)
        }
    }
}

// MARK: - CLLocationManagerDelegate (Recording the Run)
extension RunTrackerViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations as [CLLocation] {
            if location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    distance += location.distanceFromLocation(self.locations.last!)
                }
                
                //save location
                self.locations.append(location)
            }
        }
    }

    
}