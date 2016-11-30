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
    
    override func viewDidLoad() {

    }
    
    override func viewDidLayoutSubviews() {
        let border = CALayer()
        let width = CGFloat(0.5)
        border.borderColor = UIColor.darkGrayColor().CGColor
        border.frame = CGRect(x: 0, y: enterHeightTxt.frame.size.height - width, width:  enterHeightTxt.frame.size.width, height: enterHeightTxt.frame.size.height)
        
        border.borderWidth = width
        enterHeightTxt.layer.addSublayer(border)
        enterHeightTxt.layer.masksToBounds = true
        enterTargetPaceTxt.layer.addSublayer(border)
        enterTargetPaceTxt.layer.masksToBounds = true
        selectGenreTxt.layer.addSublayer(border)
        selectGenreTxt.layer.masksToBounds = true
    }
    
    
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