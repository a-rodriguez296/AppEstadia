//
//  Stay.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/10/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation

struct Stay:CustomStringConvertible {
    
    var dates:Array<NSDate>
    
    
    var description: String{
        if dates.count == 0{
            return ""
        }
        else if dates.count == 1 {
            return "De " + DateFormatHelper.mediumDate().stringFromDate(dates.first!) + " a " + DateFormatHelper.mediumDate().stringFromDate(dates.first!)
        }
        else{
            return "De " + DateFormatHelper.mediumDate().stringFromDate(dates.first!) + " a " + DateFormatHelper.mediumDate().stringFromDate(dates.last!)
        }
        
    }
    
    init(dates: Array<NSDate>){
        
        self.dates = dates
    }
    
    
    
}

