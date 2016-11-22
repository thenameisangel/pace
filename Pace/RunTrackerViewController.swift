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

class RunTrackerViewController: UIViewController, SPTAudioStreamingDelegate, SPTAudioStreamingPlaybackDelegate {
    var session: SPTSession!
    var player: SPTAudioStreamingController?


    
    @IBOutlet weak var songTitleLbl: UITextView!
    @IBOutlet weak var artistLbl: UITextView!
    @IBOutlet weak var distanceRunLbl: UITextView!
    @IBOutlet weak var timeElapsedLbl: UITextView!
    @IBOutlet weak var targetPaceLbl: UITextView!
    @IBOutlet weak var endRunBtn: UIButton!
    @IBAction func endRun(sender: AnyObject) {
        let run = NSEntityDescription.insertNewObjectForEntityForName("Run", inManagedObjectContext: managedObjectContext)
        run.setValue(NSDate(), forKey: "date")
        run.setValue(Double(distanceRunLbl.text), forKey: "distance")
        run.setValue(Double(targetPaceLbl.text), forKey: "pace")
        run.setValue(Double(timeElapsedLbl.text), forKey: "time")
        do {
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginToPlayer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startNextSong() {
        player!.playSpotifyURI("spotify:track:4TkGhMYlkcbxCMj3pny9mU", startingWithIndex: 0, startingWithPosition: 0, callback: {(error: NSError?) in
            if error != nil {
                print("Unable to play song")
            }
        })
    }
    
    func loginToPlayer() {
        
       let auth: SPTAuth = SPTAuth.defaultInstance()
        
   //     let myVC = storyboard?.instantiateViewControllerWithIdentifier("SecondVC") as! HomeViewController
        
        
        if player == nil {
            player = SPTAudioStreamingController.sharedInstance()
            
            do {
                try player?.startWithClientId(auth.clientID)
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
    }
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didReceiveError error: NSError!) {
        print(error)
    }
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
}