//
//  DatesRange.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/22/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation

struct DatesRange:CustomStringConvertible {
    
    var dates:Array<NSDate>
    
    var description: String{
        if dates.count == 0{
            return ""
        }
        else if dates.count == 1 {
            return DateFormatHelper.mediumDate().stringFromDate(dates.first!)
        }
        else{
            return DateFormatHelper.mediumDate().stringFromDate(dates.first!) + " - " + DateFormatHelper.mediumDate().stringFromDate(dates.last!)
        }
        
    }

    
    
    init(dates: Array<NSDate>){
        
        self.dates = dates
    }
    
}