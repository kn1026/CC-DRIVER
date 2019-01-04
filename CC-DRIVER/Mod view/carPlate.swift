//
//  carPlate.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/8/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class carPlate: UILabel {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1.0
        layer.cornerRadius = self.frame.width / 30
        
        
        
    }

}
