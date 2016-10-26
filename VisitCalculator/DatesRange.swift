//
//  DatesRange.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/22/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation

struct DatesRange:CustomStringConvertible {
    
    var dates:Array<Date>
    
    var description: String{
        if dates.count == 0{
            return ""
        }
        else if dates.count == 1 {
            return "\n" + DateFormatHelper.rangeDate().string(from: dates.first!)
        }
        else{
            return "\n" + DateFormatHelper.rangeDate().string(from: dates.first!) + " - " + DateFormatHelper.rangeDate().string(from: dates.last!)
        }
        
    }

    
    
    init(dates: Array<Date>){
        
        self.dates = dates
    }
    
}
