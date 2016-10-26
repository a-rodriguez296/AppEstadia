//
//  DateFormatHelper.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/10/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation

class DateFormatHelper{
    
    class func mediumDate() -> DateFormatter{
        
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        return formatter
    }
    
    class func rangeDate() -> DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter
    }
    
    class func yearResponseFormat() -> DateFormatter{
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        return formatter
    }

    
    class func stringFromDate(_ date: Date) ->String{
        return mediumDate().string(from: date)
        
    }
}
