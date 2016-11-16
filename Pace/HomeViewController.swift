//
//  ViewController.swift
//  Pace
//
//  Created by Angel Lo on 11/8/16.
//  Copyright © 2016 Angel. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginWithSpotify(sender: AnyObject) {
        //create URL to open Safari window
        
        //create authentication obj
        let auth = SPTAuth.defaultInstance()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

