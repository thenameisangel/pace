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
        searchSong()
    }
    
    func searchSong() {
        var request = NSURL(string: "")


        do {
            // get URL with parms and access token
            request = try SPTSearch.createRequestForSearchWithQuery("Fake Tales of San Francisco", queryType: SPTSearchQueryType.QueryTypeTrack, offset:1, accessToken: auth.session.accessToken).URL!
            
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
                    // decode data and print as string
//                    let responseString = String(data: data, encoding: NSUTF8StringEncoding) ?? "Data could not be printed"
//                    print(responseString)
                    
                    if let results = try NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                        print(results)
                        
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
                            print(song)
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
