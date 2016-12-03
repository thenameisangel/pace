//
//  PlaylistViewController.swift
//  Pace
//
//  Created by Neil Desai on 11/13/16.
//  Copyright © 2016 Angel. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var targetPace: String!
    
    //create temp list of song objects
    let songs: [[String]] = [["Usher", "Burn", "Confessions"],
                             ["Drake", "Marvin's Room", "Take Care"],
                             ["Chet Baker", "It's Always You", "Chet Baker Sings"],
                             ["Billy Joel", "Vienna", "The Stranger"],
                             ["Frank Sinatra", "The Way You Look Tonight", "Ultimate Sinatra"],
                             ["Cashmere Cat", "Trust Nobody", "Trust Nobody"],
                             ["Mumford and Sons", "Little Lion Man", "Sigh No More"],
                             ["Miguel", "Adorn", "Kaleidoscope Dream"],
                             ["Hailee Steinfield", "Rock Bottom", "HAIZ"],
                             ["James Arthur", "Can I Be Him", "Back from the Edge"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistSongCell", forIndexPath: indexPath) as! PlaylistSongCell
        
        cell.songLabel.text = songs[indexPath.row][2]
        cell.artistLabel.text = songs[indexPath.row][0]
        cell.albumLabel.text = songs[indexPath.row][1]
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startRunSegue"{
            let nextScene = segue.destinationViewController as! RunTrackerViewController
            nextScene.targetPace = targetPace
        }
    }
}
