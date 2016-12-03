//
//  SearchViewController.swift
//  Pace
//
//  Created by Angel Lo on 11/10/16.
//  Copyright © 2016 Angel. All rights reserved.
//

import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let auth: SPTAuth = SPTAuth.defaultInstance()
    var searchResults: [AnyObject] = []
    var keywords = ""
    var seedSong: [String:AnyObject] = [:]
    
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
//        searchSong()
    }
    
    func searchSong() {
//        var request: NSURL
    
//        testing how the SPTListPage works
//                    var searchResultPage: NSArray = []
//
//        do {
//            //this searches for the track (using QueryTypeTrack) and outputs and SPTList but I dont understand how to query the SPT list
//            //Also tried assigning searhResultPage to this, but I get an "Ambiguous Reference" error
//            try request = SPTSearch.createRequestForSearchWithQuery("Fake Tales of San Francisco", queryType: SPTSearchQueryType.QueryTypeTrack, offset:1, accessToken: auth.session.accessToken).URL!
//
//            let task = NSURLSession.sharedSession().dataTaskWithURL(request) {
//                data, response, error in
//                
//                // Check for error
//                if error != nil
//                {
//                    print("error=\(error)")
//                    return
//                }
////                
////                let response = data as! NSData!
////                print(response)
//            }
//            
//            task.resume()
//
//        } catch {
//            print("Not a valid search term")
//        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("SongResultCell", forIndexPath: indexPath) as! SongResultCell
        let song = songs[indexPath.row]
        
        cell.albumTitleLbl.text = song[2] as? String
        cell.artistNameLbl.text = song[0] as? String
        cell.songTitleLbl.text = song[1] as? String
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "songSelectSegue"{
            let playlistVC = segue.destinationViewController as! PlaylistViewController
            playlistVC.seedSong = seedSong
        }
    }

    
}
