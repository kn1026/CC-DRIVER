//
//  searchCell.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/23/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class searchCell: UITableViewCell {
    
    @IBOutlet weak var placeNameLbl: UILabel!
    @IBOutlet weak var placeAddressLbl: UILabel!
    
    var info: searchModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(_ Information: searchModel) {
        
         self.info = Information
        
        placeNameLbl.text = info.PlaceName
        placeAddressLbl.text = info.PlaceAddress
        
        
    }

}
