//
//  RunSummaryViewController.swift
//  Pace
//
//  Created by Angel Lo on 11/14/16.
//  Copyright © 2016 Angel. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import HealthKit

class RunSummaryViewController: UIViewController {
    
    @IBOutlet weak var totalRunTimeLbl: UITextView!
    @IBOutlet weak var totalRunDistanceLbl: UITextView!
    @IBOutlet weak var targetPaceLbl: UITextView!
    @IBOutlet weak var viewPlaylistBtn: UIButton!
    @IBAction func viewPlaylist(sender: AnyObject) {
    }
    
    var seconds: Double!
    var distance: Double!
    var targetPace: Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
    }

    
    func setLabels() {
        print(seconds)
        print(distance)
        print(targetPace)
        totalRunTimeLbl.text = String(seconds) + " seconds"
        totalRunDistanceLbl.text = String(distance) + " meters"
        targetPaceLbl.text = String(targetPace) + " minutes per mile"
    }
}