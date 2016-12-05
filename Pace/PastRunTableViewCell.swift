//
//  PastRunTableViewCell.swift
//  Pace
//
//  Created by Kavina Pandya on 11/13/16.
//  Copyright © 2016 Angel. All rights reserved.
//

import UIKit

class PastRunTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var runDateLbl: UILabel!
    @IBOutlet weak var distanceLbl: UILabel!
    
    @IBOutlet weak var paceLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
