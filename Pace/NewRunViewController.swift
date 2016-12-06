//
//  NewRunViewController.swift
//  Pace
//
//  Created by Angel Lo on 11/14/16.
//  Copyright © 2016 Angel. All rights reserved.
//

import Foundation
import UIKit

class NewRunViewController: UIViewController {
    
    @IBOutlet weak var searchTermTxt: UITextField!
    @IBOutlet weak var selectGenreTxt: UITextField!
    @IBOutlet weak var enterHeightTxt: UITextField!
    @IBOutlet weak var enterTargetPaceTxt: UITextField!
    @IBOutlet weak var songSearchBtn: UIButton!
    @IBOutlet weak var viewPastRunsBtn: UIButton!
    @IBOutlet weak var newPlaylistBtn: UIButton!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBAction func songSearch(sender: AnyObject) {
    }
    
    @IBAction func PastRuns(sender: UIButton) {
        self.performSegueWithIdentifier("PastRuns", sender: nil)
    }
    
    var targetPace:String!
    
    override func viewDidLoad() {
        viewPastRunsBtn.layer.borderWidth = 0.0
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    
    @IBAction func searchForSong(sender: AnyObject) {

    }
    
    @IBAction func viewNewPlaylist(sender: AnyObject) {
        targetPace = (enterTargetPaceTxt.text)!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if targetPace != "" {
            performSegueWithIdentifier("newRunPlaylistSegue", sender: nil)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // define stride length in inches
//        let strideLength = Float(enterHeightTxt.text!)! * 0.4
        if segue.identifier == "newRunPlaylistSegue"{
            let nextScene = segue.destinationViewController as? PlaylistViewController
//            let tempo = 1/(Float(targetPace)!*63360*strideLength)
            nextScene?.targetPace = targetPace
//            nextScene?.tempo = tempo
        }
        
        if segue.identifier == "searchResultsSegue" {
            let nextScene = segue.destinationViewController as? SearchViewController
            nextScene?.keywords = searchTermTxt.text!
//           nextScene?.strideLength = strideLength

        }
        
        if segue.identifier == "PastRuns"{
            let nextScene = segue.destinationViewController as? PastRunsTableViewController
            nextScene?.navBar.rightBarButtonItem = nil
        }
    }
}