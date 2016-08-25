
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
    
    var startDate:NSDate
    var endDate:NSDate
    

    
    init(startDate: NSDate, endDate: NSDate){
        self.startDate = startDate
        self.endDate = endDate
    }
    
    func substractDaysWithCount(count: Int){
        self.endDate = (self.endDate - count.days)
        self.startDate = (self.startDate - count.days)
        
        print("======================= Substracted Date =============================")
        print(DateFormatHelper.stringFromDate(endDate))
        print(DateFormatHelper.stringFromDate(startDate))
//        print(endDate)
//        print(startDate)
        print("============================ End Substracted Date ========================")
    }
    
    
    func countDaysWithinTheLastYearWithArray(datesArray: Array<Stay>) -> Int{
        
        var count = 0
        
        for stay in datesArray {
            for stayDay in stay.dates {
                if stayDay.isBetweenDates(startDate, endDate: endDate){
                    count = count + 1
                }
            }
        }
        return count
    }
    
    
    func remainingDaysWithCount(count: Int) -> Int{
        return 183 - count
    }
    
    func dateRangesWithArray(staysArray: Array<Stay>) -> Array<DatesRange>{
        
        //Define begining and end of the year
        //        let currentBeginingDate = (1.years.ago + 1.days).startOf(.Day)
        //        let currentEndDate = NSDate().endOf(.Day)
        
        var datesRanges = Array<DatesRange>()
        
        for stay in staysArray{
            
            if stay.dates.count == 1 {
                let date = stay.dates.first!
                
                //If this single date is between the
                if date.isBetweenDates(startDate, endDate: endDate) {
                    let datesRangeToAdd = DatesRange(dates: [date])
                    print(datesRangeToAdd)
                    datesRanges.append(datesRangeToAdd)
                }
            }
            else{
                
                if let dateRangeToAdd = createRangeWithStay(stay, beginingDate:startDate, endDate: endDate){
                    datesRanges.append(dateRangeToAdd)
                }
            }
        }
        
        return datesRanges
    }
    
    func createStringWithDatesRangeArray(array: Array<DatesRange>) -> String{
        
        var responseString = ""
        
        for dateRange in array {
            responseString.appendContentsOf("\n \(dateRange)")
        }
        return responseString
    }
    
    
    
    private func createRangeWithStay(stay: Stay, beginingDate: NSDate, endDate:NSDate) -> DatesRange?{
        
        
        let inferiorDate = stay.dates.first!
        let superiorDate = stay.dates.last!
        
        
        //Case when the stay dates fall outside of the range
        if superiorDate < beginingDate || inferiorDate > endDate {
            return nil
        }
            //Case when the stay dates fall in between the range
        else if inferiorDate >= beginingDate && superiorDate <= endDate{
            let projectedInferiorDate = (inferiorDate + 1.years).endOf(.Day)
            if projectedInferiorDate >= endDate &&  projectedInferiorDate <= endDate.endOf(.Year){
                var projectedSuperiorDate:NSDate?
                
                //To understand this if please check test testSemiInsideDatesRange1 in VisitCalculatorTests
                if superiorDate > (endDate - 1.years).endOf(.Year).endOf(.Day) {
                    projectedSuperiorDate = (endDate - 1.years).endOf(.Year).endOf(.Day)
                }
                else{
                    projectedSuperiorDate = superiorDate
                }
                return DatesRange(dates: [inferiorDate, projectedSuperiorDate!])
            }
            else{
                return nil
            }
        }
            //Case when one of the ends falls outside of the range
        else{
            
            //Case when superior date falls in between the range but the inferior date falls outside
            if superiorDate >= beginingDate && superiorDate <= endDate {
                let projectedInferiorDate = (beginingDate + 1.years).endOf(.Day)
                if projectedInferiorDate >= endDate &&  projectedInferiorDate <= endDate.endOf(.Year){
                    var projectedSuperiorDate:NSDate?
                    
                   
                    if superiorDate > (endDate - 1.years).endOf(.Year).endOf(.Day){
                        projectedSuperiorDate = (endDate - 1.years).endOf(.Year).endOf(.Day)
                    }
                    else{
                        projectedSuperiorDate = superiorDate
                    }
                    return DatesRange(dates: [beginingDate, projectedSuperiorDate!])
                }
                else{
                    return nil
                }
            }
                //Case when the inferior date falls in between the range but the superior date falls outside.
            else{
                let dateRange  = DatesRange(dates: [inferiorDate, endDate])
                let projectedDate = (inferiorDate + 1.years).endOf(.Day)
                let flag = projectedDate >= endDate && projectedDate <= endDate.endOf(.Year)
                return flag ? dateRange : nil
            }
        }
    }
}
