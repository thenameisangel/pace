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
    //COMMENTING OUT FOR DEMO PURPOSES
    //var runArray: [NSManagedObject] = []
    let runArray: [[String]] = [["01/12/15", "2.78 mi", "8:34\"/mi", "28:34\""],
    ["01/18/15", "2.78 mi", "8:34\"/mi", "30:34\""],
    ["01/19/15", "1.18 mi", "8:55\"/mi", "12:34\""],
    ["02/21/15", "2.36 mi", "8:01\"/mi", "20:34\""],
    ["02/30/15", "5.34 mi", "7:54\"/mi", "45:34\""],
    ["04/12/15", "6.17 mi", "7:34\"/mi", "52:34\""]]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UNCOMMENT AFTER DEMO
//        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
//        let moc = managedObjectContext
//        let runsFetch = NSFetchRequest(entityName: "Run")
//        
//        do {
//            runArray = try moc.executeFetchRequest(runsFetch) as! [NSManagedObject]
//        } catch {
//            fatalError("Failed to fetch runs: \(error)")
//        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return runArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("pastRunCell", forIndexPath: indexPath) as! PastRunTableViewCell
        
        
        cell.runDateLbl.text = runArray[indexPath.row][0]
        cell.distanceLbl.text = runArray[indexPath.row][1]
        //cell.paceLbl.text = runArray[indexPath.row][2]
        cell.timeLbl.text = runArray[indexPath.row][3]
        
//        let run = runArray[indexPath.row]
        
//        
//        cell.runDateLbl.text = run.valueForKey("date") as? String
//        cell.distanceLbl.text = run.valueForKey("distance") as? String
//        cell.paceLbl.text = run.valueForKey("pace") as? String
//        cell.timeLbl.text = run.valueForKey("time") as? String

        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
