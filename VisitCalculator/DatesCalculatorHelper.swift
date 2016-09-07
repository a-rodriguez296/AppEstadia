
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
    
    enum Operation {
        case Sum
        case Substract
    }
    
    
    
    var startDate:NSDate
    var endDate:NSDate
    
    
    init(endDate: NSDate){
        self.endDate = endDate
        self.startDate = endDate - 364.days
    }
    
    
    func changeDatesWithOperation(operation: Operation){
        
        switch operation {
        case .Sum:
            self.endDate = (self.endDate + 1.days)
            self.startDate = (self.startDate + 1.days)
        case .Substract:
            self.endDate = (self.endDate - 1.days)
            self.startDate = (self.startDate - 1.days)
        }
        print("======================= Substracted Date =============================")
        print(DateFormatHelper.stringFromDate(endDate))
        print(DateFormatHelper.stringFromDate(startDate))
        //        print(endDate)
        //        print(startDate)
        print("============================ End Substracted Date ========================")
    }
    
    
    //MARK: Count days within range

    
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
    //MARK: Create date ranges
    
    func dateRangesWithArray(staysArray: Array<Stay>) -> Array<DatesRange>{
        
        var datesRanges = Array<DatesRange>()
        
        for stay in staysArray{
            
            if let dateRangeToAdd = createRangeWithStay(stay, beginingDate:startDate, endDate: endDate){
                datesRanges.append(dateRangeToAdd)
            }
        }
        
        return datesRanges
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
                if inferiorDate != projectedSuperiorDate {
                    return DatesRange(dates: [inferiorDate, projectedSuperiorDate!])
                }
                else{
                    return DatesRange(dates: [inferiorDate])
                }
                
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
                    if beginingDate != projectedSuperiorDate {
                        return DatesRange(dates: [beginingDate, projectedSuperiorDate!])
                    }
                    else{
                        return DatesRange(dates: [beginingDate])
                    }
                    
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
    
    /*
     This function starts with the oldest date that the user entered, and loops through all the dates between such date and the 31st of December of the current year.
     The result of this function is an array of the years and a flag indicating if the user in such date is resident of not. If the user is resident,
     the result also includes the date in which he became resident.
     */
    func consolidatedCalculations(upperBoundDate:NSDate, staysArray: Array<Stay>) -> [YearResponse]{
        
        //For this function to work, this class has to be initialized with the oldest date added by the user. That is, oldest stay, first date (which is the oldest date)
        
        //upperBoundDate is the end of the current year
        
        print(DateFormatHelper.stringFromDate(startDate))
        var responseArray = Array<YearResponse>()
        
        while endDate <= upperBoundDate{
            
            let count = countDaysWithinTheLastYearWithArray(staysArray)
            let currentYear = endDate.year
            if count >= 183{
                //Resident
                responseArray.append(YearResponse(year: currentYear, flag: true, date: endDate))
                
                if (endDate.endOf(.Year)).endOf(.Day) < upperBoundDate{
                    //Fast forward untill the beggining of the next year
                    endDate = (endDate.endOf(.Year)).endOf(.Day)
                    startDate = endDate - 364.days
                }
                else{
                    return responseArray
                }
            }
            else if endDate.month == 12 && endDate.day == 31{
                responseArray.append(YearResponse(year: currentYear, flag: false, date: nil))
            }
            
            //Increase endDate by one day
            changeDatesWithOperation(.Sum)
            
        }
        return responseArray
    }
    
    
    
    //MARK: Core Data
    
    func countDaysWithinTheLastYearWithArray(datesArray: Array<CDStay>) -> Int{
        
        var count = 0
        
        for stay in datesArray {
            for stayDay in stay.dates! {
                if stayDay.date!.isBetweenDates(startDate, endDate: endDate){
                    count = count + 1
                }
            }
        }
        return count
    }
    
    func dateRangesWithArray(staysArray: Array<CDStay>) -> Array<DatesRange>{
        
        var datesRanges = Array<DatesRange>()
        
        for stay in staysArray{
            
            if let dateRangeToAdd = createRangeWithStay(stay, beginingDate:startDate, endDate: endDate){
                datesRanges.append(dateRangeToAdd)
            }
        }
        
        return datesRanges
    }
    
    private func createRangeWithStay(stay: CDStay, beginingDate: NSDate, endDate:NSDate) -> DatesRange?{
        
        
        let inferiorDate = stay.initialDate!
        let superiorDate = stay.endDate!
        
        
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
                if inferiorDate != projectedSuperiorDate {
                    return DatesRange(dates: [inferiorDate, projectedSuperiorDate!])
                }
                else{
                    return DatesRange(dates: [inferiorDate])
                }
                
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
                    if beginingDate != projectedSuperiorDate {
                        return DatesRange(dates: [beginingDate, projectedSuperiorDate!])
                    }
                    else{
                        return DatesRange(dates: [beginingDate])
                    }
                    
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
    
    func consolidatedCalculations(upperBoundDate:NSDate, staysArray: Array<CDStay>) -> [YearResponse]{
        
        //For this function to work, this class has to be initialized with the oldest date added by the user. That is, oldest stay, first date (which is the oldest date)
        
        //upperBoundDate is the end of the current year
        
        print(DateFormatHelper.stringFromDate(startDate))
        var responseArray = Array<YearResponse>()
        
        while endDate <= upperBoundDate{
            
            let count = countDaysWithinTheLastYearWithArray(staysArray)
            let currentYear = endDate.year
            if count >= 183{
                //Resident
                responseArray.append(YearResponse(year: currentYear, flag: true, date: endDate))
                
                if (endDate.endOf(.Year)).endOf(.Day) < upperBoundDate{
                    //Fast forward untill the beggining of the next year
                    endDate = (endDate.endOf(.Year)).endOf(.Day)
                    startDate = endDate - 364.days
                }
                else{
                    return responseArray
                }
            }
            else if endDate.month == 12 && endDate.day == 31{
                responseArray.append(YearResponse(year: currentYear, flag: false, date: nil))
            }
            
            //Increase endDate by one day
            changeDatesWithOperation(.Sum)
            
        }
        return responseArray
    }
    
}
