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
    var playlist: [AnyObject] = []
    let auth: SPTAuth = SPTAuth.defaultInstance()
    
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
        loadPlaylist()
        
    }
    
    func loadPlaylist() {
        // Send HTTP GET Request to retrieve recommended songs
        
        // Set target args
        let genre = "hip-hop"
        let tempo = 180.0
        let market = "US"
        let limit = 100
        
        // Define server side script URL
        let scriptUrl = "https://api.spotify.com/v1/recommendations"
        
        // Add parms
        let urlWithParms = scriptUrl + "?limit=\(limit)&seed_genres=\(genre)&target_tempo=\(tempo)&market=\(market)"
        
        // Create NSURL Object
        let myUrl = NSURL(string: urlWithParms);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(URL: myUrl!);
        
        // Set request HTTP method to GET. It could be POST as well
        request.HTTPMethod = "GET"
        
        let headersAuth = NSString(format: "Bearer %@", auth.session.accessToken)
        
        // Add Authorization Token value
        request.addValue(headersAuth as String, forHTTPHeaderField: "Authorization")
        
        // Excute HTTP Request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            //            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //            print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // cast tracks as an array of dictionaries
                    let tracks = convertedJsonIntoDict["tracks"] as! [[String:AnyObject]]
                    
                    // access each track information
                    for i in 0..<tracks.count {
                        
                        // store song details
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
                            "uri": uri
                        ]
                        
                        // add song to playlist
                        self.playlist.append(song)
                        
                    }
                    
                    // print playlist
                    print(self.playlist)
                    print("Number of songs: \(self.playlist.count)")
                }
                
                // print error if request fails
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
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
            //nextScene.targetPace = targetPace
            
            // pass curated playlist to the run tracker
            nextScene.playlist = self.playlist
        }
    }
}
