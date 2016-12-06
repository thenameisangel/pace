//
//  NewRunViewController.swift
//  Pace
//
//  Created by Angel Lo on 11/14/16.
//  Copyright © 2016 Angel. All rights reserved.
//

import Foundation
import UIKit

class NewRunViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var searchTermTxt: UITextField!
    @IBOutlet weak var selectGenreTxt: UITextField!
    @IBOutlet weak var enterHeightTxt: UITextField!
    @IBOutlet weak var enterTargetPaceTxt: UITextField!
    @IBOutlet weak var songSearchBtn: UIButton!
    @IBOutlet weak var viewPastRunsBtn: UIButton!
    @IBOutlet weak var newPlaylistBtn: UIButton!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBAction func songSearch(sender: AnyObject) {
    }
    var height = 0
    var genre = ""
    
    @IBAction func PastRuns(sender: UIButton) {
        self.performSegueWithIdentifier("PastRuns", sender: nil)
    }
    
    // MARK: Pickers
   
    @IBOutlet weak var genrePicker: UIPickerView!
    
    let genres = [ "acoustic", "afrobeat", "alt-rock", "alternative", "ambient", "anime", "black-metal", "bluegrass", "blues", "bossanova", "brazil", "breakbeat", "british", "cantopop", "chicago-house", "children", "chill", "classical", "club", "comedy", "country", "dance", "dancehall", "death-metal", "deep-house", "detroit-techno", "disco", "disney", "drum-and-bass", "dub", "dubstep", "edm", "electro", "electronic", "emo", "folk", "forro", "french", "funk", "garage", "german", "gospel", "goth", "grindcore", "groove", "grunge", "guitar", "happy", "hard-rock", "hardcore", "hardstyle", "heavy-metal", "hip-hop", "holidays", "honky-tonk", "house", "idm", "indian", "indie", "indie-pop", "industrial", "iranian", "j-dance", "j-idol", "j-pop", "j-rock", "jazz", "k-pop", "kids", "latin", "latino", "malay", "mandopop", "metal", "metal-misc", "metalcore", "minimal-techno", "movies", "mpb", "new-age", "new-release", "opera", "pagode", "party", "philippines-opm", "piano", "pop", "pop-film", "post-dubstep", "power-pop", "progressive-house", "psych-rock", "punk", "punk-rock", "r-n-b", "rainy-day", "reggae", "reggaeton", "road-trip", "rock", "rock-n-roll", "rockabilly", "romance", "sad", "salsa", "samba", "sertanejo", "show-tunes", "singer-songwriter", "ska", "sleep", "songwriter", "soul", "soundtracks", "spanish", "study", "summer", "swedish", "synth-pop", "tango", "techno", "trance", "trip-hop", "turkish", "work-out", "world-music" ]
    
    @IBOutlet weak var heightPicker: UIPickerView!
    
    let heightsArray = [48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83]
    
    let heights = ["4' 0\"", "4' 1\"", "4' 2\"", "4' 3\"", "4' 4\"", "4' 5\"", "4' 6\"", "4' 7\"", "4' 8\"", "4' 9\"", "4' 10\"", "4' 11\"", "5' 0\"", "5' 1\"", "5' 2\"", "5' 3\"", "5' 4\"", "5' 5\"", "5' 6\"", "5' 7\"", "5' 8\"", "5' 9\"", "5' 10\"", "5' 11\"", "6' 0\"", "6' 1\"", "6' 2\"", "6' 3\"", "6' 4\"", "6' 5\"", "6' 6\"", "6' 7\"", "6' 8\"", "6' 9\"", "6' 10\"", "6' 11\"", ]
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag == 1) {
            return genres.count
        }
        
        else {
            return heights.count
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        
        let label = UILabel()
        
        label.font = UIFont(name: "Avenir", size: 12.0)
        label.textAlignment = .Center
        
        if (pickerView.tag == 1) {
            label.text = genres[row]
            
        }
        
        else {
            label.text = heights[row]
            
        }
        return label
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (pickerView.tag == 1) {
            genre = genres[row]
            print("Genre set to \(genre)")
        }
        
        if (pickerView.tag == 2) {
            height = heightsArray[row]
            print("Height set to \(height)")
        }
        
    }
    
    var targetPace:String!
    
    override func viewDidLoad() {
        viewPastRunsBtn.layer.borderWidth = 0.0
    
    }
    
    override func viewDidLayoutSubviews() {

    }
    
    
    @IBAction func searchForSong(sender: AnyObject) {

    }
    
    @IBAction func viewNewPlaylist(sender: AnyObject) {
        targetPace = (enterTargetPaceTxt.text)!.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if targetPace != "" {
            performSegueWithIdentifier("newRunPlaylistSegue", sender: nil)
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // define stride length in inches
        let strideLength = Float(height) * 0.855
        if segue.identifier == "newRunPlaylistSegue"{
            let nextScene = segue.destinationViewController as? PlaylistViewController
            let tempo = 1/(Float(targetPace)!*(1/63360)*strideLength)
            nextScene?.targetPace = targetPace
            nextScene?.tempo = tempo
            nextScene?.genre = genre
        }
        
        if segue.identifier == "searchResultsSegue" {
            let nextScene = segue.destinationViewController as? SearchViewController
            nextScene?.keywords = searchTermTxt.text!
           nextScene?.strideLength = strideLength

        }
        
        if segue.identifier == "PastRuns"{
            let nextScene = segue.destinationViewController as? PastRunsTableViewController
            nextScene?.navBar.rightBarButtonItem = nil
        }
    }
}