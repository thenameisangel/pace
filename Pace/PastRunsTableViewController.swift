//
//  PastRunsTableViewController.swift
//  Pace
//
//  Created by Kavina Pandya on 11/13/16.
//  Copyright © 2016 Angel. All rights reserved.
//

import UIKit
import CoreData

class PastRunsTableViewController: UITableViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var newRunButton: UIBarButtonItem!
    
    // MARK: Actions
    
    @IBAction func newRun(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier("newRun", sender: nil)
    }
    
    // MARK: Prepare Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "newRun" {
            let vc = segue.destinationViewController as! NewRunViewController
            vc.navBar.hidesBackButton = true
        }
        
        if segue.identifier == "runSummary" {
            let vc = segue.destinationViewController as! RunSummaryViewController
            let index = tableView.indexPathForSelectedRow!.row
            let run = Runs[index]
            vc.run = run
        }
    }
    
    // MARK: Variables
    
    var Runs = [NSManagedObject]()
    var managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchRuns()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Fetching
    
    func fetchRuns() {
        
        let fetchRequest = NSFetchRequest(entityName: "Run")
        
        do {
            let results = try managedContext.executeFetchRequest(fetchRequest)
            Runs = results as! [NSManagedObject]
        }
            
        catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    // MARK: - Table View Data Source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Runs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pastRunCell", forIndexPath: indexPath) as! PastRunTableViewCell
        
        let run = Runs[indexPath.row]
        
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "MM/dd/yyyy"
        let date = run.valueForKey("timestamp") as! NSDate
        let newdate = dateformatter.stringFromDate(date)
        
        let distance = run.valueForKey("distance") as! Float
        let duration = run.valueForKey("duration") as! Float
        
        let actualpace = distance/duration
        
        cell.runDateLbl.text = String(newdate)
        cell.distanceLbl.text = String(distance) + " mi"
        cell.paceLbl.text = String(actualpace) + " mi/min"
        cell.timeLbl.text = String(duration) + " min"

        return cell
    }

}
