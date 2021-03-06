//
//  DateFormatHelper.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/10/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation

class DateFormatHelper{
    
    class func mediumDate() -> NSDateFormatter{
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return formatter
    }
    
    class func rangeDate() -> NSDateFormatter{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter
    }
    
    class func yearResponseFormat() -> NSDateFormatter{
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }

    
    class func stringFromDate(date: NSDate) ->String{
        return mediumDate().stringFromDate(date)
        
    }
}
