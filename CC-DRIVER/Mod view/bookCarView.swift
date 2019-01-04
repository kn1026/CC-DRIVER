//
//  bookCarView.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 3/26/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class bookCarView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: self.frame.height / 7, height: self.frame.height / 7)).cgPath
        
        
        
        //Here I'm masking the textView's layer with rectShape layer
        layer.mask = rectShape
        
        
    }

}
