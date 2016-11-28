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
    
    @IBOutlet weak var selectGenreTxt: UITextField!
    @IBOutlet weak var enterHeightTxt: UITextField!
    @IBOutlet weak var enterTargetPaceTxt: UITextField!
    @IBOutlet weak var songSearchBtn: UIButton!
    @IBOutlet weak var viewPastRunsBtn: UIButton!
    @IBOutlet weak var newPlaylistBtn: UIButton!
    @IBAction func songSearch(sender: AnyObject) {
    }
    @IBAction func viewPastRuns(sender: AnyObject) {
    }
    var targetPace:String!
    @IBAction func viewNewPlaylist(sender: AnyObject) {
        targetPace = (enterTargetPaceTxt.text)!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if targetPace != "" {
            performSegueWithIdentifier("newRunPlaylistSegue", sender: nil)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newRunPlaylistSegue"{
            let nextScene = segue.destinationViewController as? PlaylistViewController
            nextScene?.targetPace = targetPace
        }
    }
}