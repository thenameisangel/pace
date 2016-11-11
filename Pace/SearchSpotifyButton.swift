//
//  SearchSpotifyButton.swift
//  Pace
//
//  Created by Nednur, Adarsh on 11/10/16.
//  Copyright © 2016 Angel. All rights reserved.
//

import UIKit

@IBDesignable

class SearchSpotifyButton: UIButton {

    override func drawRect(rect: CGRect) {
        let path = UIBezierPath(ovalInRect: rect)
        UIColor.greenColor().setFill()
        path.fill()
    }

}
