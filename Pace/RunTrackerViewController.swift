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

class RunTrackerViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var songLbl: UITextView!
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
}