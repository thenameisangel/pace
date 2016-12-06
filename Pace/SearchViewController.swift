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
    var seedSong: [String: AnyObject] = [:]
    var strideLength: Float!
    
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
        searchSong()
    }
    
    func searchSong() {
        var request = NSURL(string: "")


        do {
            // get URL with parms and access token
            request = try SPTSearch.createRequestForSearchWithQuery(self.keywords, queryType: SPTSearchQueryType.QueryTypeTrack, offset:1, accessToken: auth.session.accessToken).URL!
            
            // turn URL into URLRequest
            let request = NSMutableURLRequest(URL: request!);
            
            // get data from GET request
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                data, response, error in
                
                if error != nil
                {
                    print("error = \(error)")
                    return
                }
                
                if let data = data {
                do {
                    
                    if let results = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
            
                        let tracks = results["tracks"]!["items"] as! [[String:AnyObject]]
                        
                        for i in 0..<tracks.count {
                            // store song details
                            let album = tracks[i]["album"]!["name"] as! String
                            let uri = tracks[i]["uri"] as! String
                            let id = tracks[i]["id"] as! String
                            let songTitle = tracks[i]["name"] as! String
                            let allArtists = tracks[i]["artists"] as! NSArray
                        
                            // add multiple artists on a track to an array
                            var artists: [String] = []

                            for j in 0..<allArtists.count {
                                let artist = allArtists[j] as! NSDictionary
                                let artistName = artist["name"] as! String
                                artists.append(artistName)
                            }

                            // create song object
                            let song: [String: AnyObject] = [
                                "id": id,
                                "artists": artists,
                                "title": songTitle,
                                "album": album,
                                "uri": uri
                            ]
                            
                            // add song to search results
                            self.searchResults.append(song)
                            
                            // reload table after json data is appended to playlist array
                            dispatch_async(dispatch_get_main_queue(), {
                                self.tableView.reloadData()
                            })
                        }

                    }
                    
                } catch let error as NSError {
                    print(error.localizedDescription)
                    }
                } else if let error = error {
                    print(error.localizedDescription)
                }

            }
                task.resume()

            }
            
        // catch SPT search request
        catch let error as NSError {
            print("Error: \(error)")
        }
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("SongResultCell", forIndexPath: indexPath) as! SongResultCell
        let song = searchResults[indexPath.row]
        
        // Populate cell song and album
        cell.songTitleLbl.text = song["title"] as? String
        cell.albumTitleLbl.text = song["album"] as? String
        
        // Populate artist
        if (song["artists"] != nil) {
            let artists = song["artists"] as! NSArray
            
            // Handle multiple artists
            if artists.count < 1 {
                cell.artistNameLbl.text = artists[0] as? String
            } else {
                let artist = artists[0] as! String
                let features = artists.componentsJoinedByString(", ")
                cell.artistNameLbl.text = "\(artist) feat. \(features)"
            }
        }
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?){
        if segue.identifier == "songSelectSegue"{
            let playlistVC = segue.destinationViewController as! PlaylistViewController
            let index = tableView.indexPathForSelectedRow!.row
            playlistVC.seedSong = self.searchResults[index] as! [String:AnyObject]
            playlistVC.strideLength = strideLength
        }
    }

    
}
