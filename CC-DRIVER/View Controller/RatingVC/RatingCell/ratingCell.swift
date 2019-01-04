//
//  ratingCell.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/8/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class ratingCell: UITableViewCell {
    
    @IBOutlet weak var commentLbl: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    @IBOutlet weak var timeLbl: UILabel!
    
    let yellow = UIImage(named: "yellow star")
    let empty = UIImage(named: "starnofill")
    
    var info: ratingModel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    func configureCell(_ Information: ratingModel) {
        self.info = Information

        
        
        if info.Text != "nil" {
            
            commentLbl.text = "\"\(info.Text!)\""
            
        } else {
            
            
            commentLbl.text = ""
            
        }
        
        
        let time = info.Timestamp as? TimeInterval
        
        if time != nil {
            
            let date = Date(timeIntervalSince1970: time!/1000)
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = DateFormatter.Style.short
            let times = timeFormatter.string(from: date)
            if dayDifference(from: date) == "Today" {
                
                timeLbl.text = "Today \(times)"
                
            } else if dayDifference(from: date) == "Yesterday" {
                
                timeLbl.text = "Yesterday \(times)"
                
            } else {
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = DateFormatter.Style.medium
                let Dateresult = dateFormatter.string(from: date)
                
                
                timeLbl.text = "\(Dateresult) \(times)"
                
                
            }
            
        }
        
        
        
        
        
        if info.Rate! == 5 {
            
            star1.image = yellow
            star2.image = yellow
            star3.image = yellow
            star4.image = yellow
            star5.image = yellow
            
            
        } else if info.Rate! == 4 {
            
            star1.image = yellow
            star2.image = yellow
            star3.image = yellow
            star4.image = yellow
            star5.image = empty
            
        } else if info.Rate! == 3 {
            
            
            star1.image = yellow
            star2.image = yellow
            star3.image = yellow
            star4.image = empty
            star5.image = empty
            
            
        } else if info.Rate! == 2 {
            
            star1.image = yellow
            star2.image = yellow
            star3.image = empty
            star4.image = empty
            star5.image = empty
            
            
        } else if info.Rate! == 1 {
            
            
            star1.image = yellow
            star2.image = empty
            star3.image = empty
            star4.image = empty
            star5.image = empty
            
        } else {
            
            star1.image = empty
            star2.image = empty
            star3.image = empty
            star4.image = empty
            star5.image = empty
            
        }
        
        
        
        
    }
    
    func dayDifference(from date : Date) -> String
    {
        let calendar = NSCalendar.current
        if calendar.isDateInYesterday(date) { return "Yesterday" }
        else if calendar.isDateInToday(date) { return "Today" }
        else if calendar.isDateInTomorrow(date) { return "Tomorrow" }
        else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.day], from: startOfNow, to: startOfTimeStamp)
            let day = components.day!
            if day < 1 { return "\(abs(day)) days ago" }
            else { return "In \(day) days" }
        }
    }
   
    
    
    

}
