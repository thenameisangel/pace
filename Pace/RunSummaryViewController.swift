//
//  RunSummaryViewController.swift
//  Pace
//
//  Created by Angel Lo on 11/14/16.
//  Copyright © 2016 Angel. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import HealthKit
import CoreData
import MapKit

class RunSummaryViewController: UIViewController {
    
    // MARK: Properties
    @IBOutlet weak var mapView: MKMapView!

    @IBOutlet weak var distanceLabel: UITextView!
    @IBOutlet weak var durationLabel: UITextView!
    @IBOutlet weak var paceLabel: UITextView!
    @IBOutlet weak var targetpaceLabel: UITextView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    // MARK: Actions

    @IBOutlet weak var viewPlaylist: UIButton!
    
    @IBAction func pastRuns(sender: UIButton) {
        self.performSegueWithIdentifier("viewPastRuns", sender: self)
    }
    
    // MARK: Prepare Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "viewPastRuns"{
            let vc = segue.destinationViewController as! PastRunsTableViewController
            vc.navBar.hidesBackButton = true
        }
    }
    
    // MARK: Variables
    var run: NSManagedObject!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLabels()
        loadMap()
    }
    
    // MARK: Set Labels
    func setLabels() {
        let distance = run.valueForKey("distance") as! Float
        let duration = run.valueForKey("duration") as! Float
        
        distanceLabel.text = String(distance)
        durationLabel.text = String(duration)
        paceLabel.text = String(distance/duration)
        
        // Label Formatting
        distanceLabel.font = UIFont(name: "Avenir", size: 17)
        distanceLabel.textAlignment = .Center
        durationLabel.font = UIFont(name: "Avenir", size: 17)
        durationLabel.textAlignment = .Center
        paceLabel.font = UIFont(name: "Avenir", size: 17)
        paceLabel.textAlignment = .Center
        targetpaceLabel.font = UIFont(name: "Avenir", size: 17)
        targetpaceLabel.textAlignment = .Center
    }
    
    // MARK: Generate Map Overlay
    
    // Map Region
    func mapRegion() -> MKCoordinateRegion{
        
        let locations = run.valueForKey("locations") as! NSSet
        let initialLocation = locations.allObjects.first
        
        var minLat = initialLocation!.valueForKey("latitude") as! Double
        var minLong = initialLocation!.valueForKey("longitude") as! Double
        var maxLat = initialLocation!.valueForKey("latitude") as! Double
        var maxLong = initialLocation!.valueForKey("longitude") as! Double
        
        for location in locations {
            minLat = min(minLat, location.valueForKey("latitude") as! Double)
            minLong = min(minLong, location.valueForKey("longitude") as! Double)
            maxLat = max(maxLat, location.valueForKey("latitude") as! Double)
            maxLong = max(maxLong, location.valueForKey("longitude") as! Double)
        }
        
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLong + maxLong)/2),
            span: MKCoordinateSpan(latitudeDelta: (maxLat - minLat)*1.5, longitudeDelta: (maxLong - minLong)*1.5))
    }
    
    // Overlay Properties
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if overlay is MKPolyline {
            let polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 3
            return polylineRenderer
        }
        
        return nil
    }
    
    // Overlay Path
    func polyline() -> MKPolyline {
        var coords = [CLLocationCoordinate2D]()
        
        let locations = run.valueForKey("locations") as! NSSet
        
        let descriptor = NSSortDescriptor(key: "timestamp", ascending: true)
        let sortedlocations: NSArray = locations.sortedArrayUsingDescriptors([descriptor])
        
        for location in sortedlocations {
            let coord = CLLocationCoordinate2D(latitude: location.valueForKey("latitude") as! Double, longitude: location.valueForKey("longitude") as! Double)
            
            coords.append(coord)
        }
        
        return MKPolyline(coordinates: &coords, count: sortedlocations.count)
    }
    
    // Load Map
    func loadMap() {
        let locations = run.valueForKey("locations") as! NSSet
        
        if locations.count > 0 {
            mapView.hidden = false
            
            // Set the map bounds
            mapView.region = mapRegion()
            
            // Make the line(s!) on the map
            mapView.addOverlay(polyline())
        }
        
    }

}