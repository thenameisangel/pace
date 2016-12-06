//
//  SpotifyStyleButton.swift
//  test
//
//  Created by Nednur, Adarsh on 12/5/16.
//  Copyright © 2016 Nednur, Adarsh. All rights reserved.
//

import UIKit

@IBDesignable

class SpotifyStyleButton: UIButton {
    
    override func drawRect(rect: CGRect) {
        let path = UIBezierPath()
        
        
        //move the initial point of the path
        //to the start of the horizontal stroke
        path.moveToPoint(CGPoint(
            x:bounds.width * 0.9,
            y:0))
        
        path.addLineToPoint(CGPoint(
            x:bounds.width * 0.1,
            y:0))
        
        path.addArcWithCenter(CGPoint(
            x:bounds.width * 0.1,
            y:bounds.height/2), radius: CGFloat(bounds.height/2), startAngle: CGFloat(3*M_PI/2), endAngle: CGFloat(M_PI/2), clockwise: false)
        
        path.addLineToPoint(CGPoint(
            x:bounds.width * 0.9,
            y:bounds.height))
        
        path.addArcWithCenter(CGPoint(
            x:bounds.width * 0.9,
            y:bounds.height/2), radius: CGFloat(bounds.height/2), startAngle: CGFloat(M_PI/2), endAngle: CGFloat(3*M_PI/2), clockwise: false)
        
        //set the stroke color
        let spotifyColor = UIColor(red: 0x00, green: 0x80, blue: 0xFF)
        
        spotifyColor.setFill()
        
        //draw the stroke
        path.fill()
        
        
    }
    
    
}




extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}