//
//  LineSeparatorView.swift
//  Pace
//
//  Created by Nednur, Adarsh on 11/28/16.
//  Copyright © 2016 Angel. All rights reserved.
//

import UIKit

@IBDesignable

class LineSeparatorView: UIView {
    override func drawRect(rect: CGRect) {
        //set up the width and height variables
        //for the horizontal stroke
        let lineWidth: CGFloat = 3.0
        let lineHeight: CGFloat = max(bounds.width, bounds.height)
        
        //create the path
        let linePath = UIBezierPath()
        
        //set the path's line width to the width of the stroke
        linePath.lineWidth = lineWidth

        //Vertical Line
        
        //move to the start of the vertical stroke
        linePath.moveToPoint(CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 - lineHeight/2 + 0.5))
        
        //add the end point to the vertical stroke
        linePath.addLineToPoint(CGPoint(
            x:bounds.width/2 + 0.5,
            y:bounds.height/2 + lineHeight/2 + 0.5))
        
        //set the stroke color
        UIColor.blackColor().setStroke()
        
        //draw the stroke
        linePath.stroke()
    }

}
