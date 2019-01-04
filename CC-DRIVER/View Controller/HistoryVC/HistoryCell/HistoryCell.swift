//
//  HistoryCell.swift
//  Campus Connect
//
//  Created by Khoi Nguyen on 4/8/18.
//  Copyright © 2018 Campus Connect LLC. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var destinationAddressLbl: UILabel!
    @IBOutlet weak var moneyLbl: UILabel!
    @IBOutlet weak var progressLbl: UILabel!
    var info: HistoryModel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCell(_ Information: HistoryModel) {
        self.info = Information
        
        
        
        destinationAddressLbl.text = "Went to \(info.DestinationName!)"
        progressLbl.text = info.Progess!
        
        progressLbl.text = info.Progess!
        if info.Progess! == "Canceled" {
            
            progressLbl.textColor = UIColor.red
            
        }
        
        
        moneyLbl.text = "$\(info.price!)"
        
        let time = info.Timestamp as? TimeInterval
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
