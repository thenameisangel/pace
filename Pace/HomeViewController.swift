//
//  ViewController.swift
//  Pace
//
//  Created by Angel Lo on 11/8/16.
//  Copyright © 2016 Angel. All rights reserved.
//
import UIKit

class HomeViewController: UIViewController {
    let clientID = "7884d212f6ef45b5b4691688644f1217"
    let callURL = "pace://returnAfterLogin"
    let tokenSwapURL = "http://localhost:1234/swap"
    let tokenRefreshServiceURL = "http://localhost:1234/refresh"
    
    @IBOutlet weak var loginButton: UIButton!
    var session:SPTSession!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let auth = SPTAuth.defaultInstance()
        
        if auth.session == nil {
            print("No token/session exists")
            return
        }
        
        if auth.session.isValid() {
            print("Valid session exists")
            return
        }
        
    }
    
    @IBAction func loginWithSpotify(sender: AnyObject) {
        let auth = SPTAuth.defaultInstance()
        
        auth.clientID = clientID
        auth.redirectURL = NSURL(string:callURL)
        auth.tokenRefreshURL = NSURL(string: tokenRefreshServiceURL)
        auth.tokenSwapURL = NSURL(string:tokenSwapURL)
        auth.requestedScopes = [SPTAuthStreamingScope]
        
        let loginURL = auth.spotifyWebAuthenticationURL()
        print("Login URL: \(loginURL)")
        
        UIApplication.sharedApplication().openURL(loginURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}