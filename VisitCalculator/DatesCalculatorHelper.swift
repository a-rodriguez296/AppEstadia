
//
//  DatesCalculator.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/22/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import SwiftDate

class DatesCalculatorHelper{
    
    class func countDaysWithinTheLastYearWithArray(datesArray: Array<Stay>) -> Int{
        
        
        let beginingDate = (1.years.ago + 1.days).startOf(.Day)
        let endDate = (NSDate().endOf(.Year)).endOf(.Day)
        
//        print(DateFormatHelper.mediumDate().stringFromDate(beginingDate))
//        print(DateFormatHelper.mediumDate().stringFromDate(endDate))
        
        var count = 0
        
        for stay in datesArray {
            for stayDay in stay.dates {
                if stayDay.isBetweenDates(beginingDate, endDate: endDate){
                    count = count + 1
                }
            }
        }
        
        return count
    }
}
