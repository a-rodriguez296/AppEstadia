
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
    
    static let beginingDate = (1.years.ago + 1.days).startOf(.Day)
    
    static let endDate = (NSDate().endOf(.Year)).endOf(.Day)
    
    class func countDaysWithinTheLastYearWithArray(datesArray: Array<Stay>) -> Int{
        
        
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
    
    
    class func remainingDaysWithCount(count: Int) -> Int{
        return 183 - count
    }
    
    class func dateRangesWithArray(staysArray: Array<Stay>) -> Array<DatesRange>{
        
        //Define begining and end of the year
        let currentBeginingDate = (1.years.ago + 1.days).startOf(.Day)
        let currentEndDate = NSDate().endOf(.Day)
        
        
        var datesRanges = Array<DatesRange>()
        
        for stay in staysArray{
            
            if stay.dates.count == 1 {
                let date = stay.dates.first!
                
                //If this single date is between the
                if date.isBetweenDates(currentBeginingDate, endDate: currentEndDate) {
                    let datesRangeToAdd = DatesRange(dates: [date])
                    print(datesRangeToAdd)
                    datesRanges.append(datesRangeToAdd)
                }
            }
            else{
                
                if let dateRangeToAdd = createRangeWithStay(stay, beginingDate:currentBeginingDate, endDate: currentEndDate){
                    datesRanges.append(dateRangeToAdd)
                }
            }
        }
        
        return datesRanges
    }
    
    
    private class func createRangeWithStay(stay: Stay, beginingDate: NSDate, endDate:NSDate) -> DatesRange?{
        
        
        let inferiorDate = stay.dates.first!
        let superiorDate = stay.dates.last!
        
        
        //Case when the stay dates fall outside of the range
        if superiorDate < beginingDate || inferiorDate > endDate {
            return nil
        }
            //Case when the stay dates fall in between the range
        else if inferiorDate >= beginingDate && superiorDate <= endDate{
            let a = DatesRange(dates: [inferiorDate, superiorDate])
            print(a)
            return a
        }
            //Case when one of the ends falls outside of the range
        else{
            
            //Case when superior date falls in between the range but the inferior date falls outside
            if superiorDate >= beginingDate && superiorDate <= endDate {
                let a = DatesRange(dates: [beginingDate, superiorDate])
                print(a)
                return a
            }
                //Case when the inferior date falls in between the range but the superior date falls outside.
            else{
                let a  = DatesRange(dates: [inferiorDate, endDate])
                print(a)
                return a
            }
        }
    }
}
