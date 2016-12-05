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
    var seedSong: [String: AnyObject] = [:]
    var username = ""
    var genre = "hip-hop"
    var tempo: Float = 180.0
    let market = "US"
    let auth: SPTAuth = SPTAuth.defaultInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seedTempo()
        getUserId()
    }
    
    
    func createPlaylist() {
        // POST: Create a playlist on the current user's account
        
        // Create NSURL Object
        print("Username for POST: \(username)")
        let myUrl = NSURL(string: "https://api.spotify.com/v1/users/\(username)/playlists");
        
        // Creaste URL Request
        let request = NSMutableURLRequest(URL: myUrl!);
        
        // Set request HTTP method
        request.HTTPMethod = "POST"
        
        // Add access token and content type to header
        let headersAuth = NSString(format: "Bearer %@", auth.session.accessToken)
        let contentType = "application/json"
        request.addValue(headersAuth as String, forHTTPHeaderField: "Authorization")
        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
        
        // Add data to body of HTTP request
        do {
            // Create data for sending
            let data = ["name": "Pace Sample Playlist", "public": false] as Dictionary
            
            // Convert to json
            let jsonData = try NSJSONSerialization.dataWithJSONObject(data, options: NSJSONWritingOptions.PrettyPrinted)
            
            // Attach data to body of request
            request.HTTPBody = jsonData
            
        } catch let error as NSError {
            print("JSON preparation error: \(error)")
        }
        
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
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            // Convert server json response to NSDictionary
            //            do {
            //                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
            //
            //                    // cast details as an array of dictionaries
            //                    let details = convertedJsonIntoDict["id"] as! String
            //
            //                    // update user id
            //                    dispatch_async(dispatch_get_main_queue(), {
            //                        self.username = details
            //                    })
            //                }
            //
            //                // print error if request fails
            //            } catch let error as NSError {
            //                print(error.localizedDescription)
            //            }
            
        }
        
        task.resume()
    }
    

    
    func seedTempo() {
        // SAMPLE URL "https://api.spotify.com/v1/audio-features/SONGID"
        
        // Define server side script URL
        let scriptUrl = "https://api.spotify.com/v1/audio-features/"
        
        // Add parms
        let songID = seedSong["id"] as! String
        let urlWithParms = scriptUrl + songID
        
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
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
            do {
                if let attributes = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    self.tempo = attributes["tempo"] as! Float
                    print("Pulled song tempo: \(self.tempo)")
                    
                    }
                
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        print("Seed tempo: \(self.tempo)")
                        self.loadPlaylist()
                    })
                
                // print error if request fails
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
        
    }
    
    func loadPlaylist() {
        // Send HTTP GET Request to retrieve recommended songs
   
        // target number of search results, MAX = 100
        let limit = 100
        
        // Define server side script URL
        let scriptUrl = "https://api.spotify.com/v1/recommendations"
        
        // Add parms
        let urlWithParms = scriptUrl + "?limit=\(limit)&seed_genres=\(self.genre)&target_tempo=\(self.tempo)&market=\(self.market)"
        
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
       
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // cast tracks as an array of dictionaries
                    let tracks = convertedJsonIntoDict["tracks"] as! [[String:AnyObject]]
                    
                    // access each track information
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
                        
                        // add song to playlist
                        self.playlist.append(song)
                        
                    }
                    
                    // reload table after json data is appended to playlist array
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                }
                
                // print error if request fails
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
    }
    
    func getUserId() {

        // Send HTTP GET Request to retrieve recommended songs
        
        // Create NSURL Object
        let myUrl = NSURL(string: "https://api.spotify.com/v1/me");
        
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
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // cast details as an array of dictionaries
                    let details = convertedJsonIntoDict["id"] as! String
                    
                    // update user id
                    dispatch_async(dispatch_get_main_queue(), {
                        self.username = details
                        self.createPlaylist()
                    })
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
        return playlist.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PlaylistSongCell", forIndexPath: indexPath) as! PlaylistSongCell
        let song = playlist[indexPath.row]
        
        // Populate cell song and album
        cell.songLabel.text = song["title"] as? String
        cell.albumLabel.text = song["album"] as? String
        
        // Populate artist
        if (song["artists"] != nil) {
            let artists = song["artists"] as! NSArray
            
            // Handle multiple artists
            if artists.count < 1 {
                cell.artistLabel.text = artists[0] as! String
            } else {
                let artist = artists[0] as! String
                let features = artists.componentsJoinedByString(", ")
                cell.artistLabel.text = "\(artist) feat. \(features)"
            }
            
        }

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "startRunSegue"{
            let nextScene = segue.destinationViewController as! RunTrackerViewController
            // pass target pace to the run tracker
            //nextScene.targetPaceLbl.text = targetPace
            
            // pass curated playlist to the run tracker
            nextScene.playlist = self.playlist
        }
    }
}
