//
//  VisitCalculatorTests.swift
//  VisitCalculatorTests
//
//  Created by Alejandro Rodriguez on 8/23/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import XCTest
import SwiftDate


@testable import VisitCalculator
class VisitCalculatorTests: XCTestCase {
    
    let fiveYears = 365*5
    
    
    var staysArray = Array<Stay>()
    var datesCalculator:DatesCalculatorHelper?
    
    override func setUp() {
        super.setUp()
        
        print("============== Initial Dates =================")
        let now = NSDate().endOf(.Day).endOf(.Day)//NSDate(year: 2012, month: 12, day: 31).endOf(.Day)
        let oneFiscalYearAgo = (now - 364.days)
        datesCalculator = DatesCalculatorHelper(endDate:now)
        //        datesCalculator = DatesCalculatorHelper(startDate: NSDate(year: 2014, month: 12, day:31).startOf(.Day), endDate:NSDate(year: 2015, month: 12, day: 30).startOf(.Day))
        print(DateFormatHelper.stringFromDate(now))
        print(DateFormatHelper.stringFromDate(oneFiscalYearAgo))
        print(datesCalculator!.startDate)
        print(datesCalculator!.endDate)
        print("============= End Initial Dates")
    }
    
    override func tearDown() {
        super.tearDown()
        
        staysArray = Array<Stay>()
        datesCalculator = nil
    }
    
    func initializeDates(count: Int){
        datesCalculator!.changeDatesWithOperation(.Substract)
    }
    
    
    //MARK: Inside dates
    
    func testDatesInside(){
        
        let insideStay = createInsideDates()
        
        staysArray.appendContentsOf([insideStay])
        
        let count = datesCalculator!.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 3)
    }
    
    func testDatesInsideAllYear(){
        
        for _ in 1...fiveYears{
            
            initializeDates(1)
            staysArray.removeAll()
            
            let insideStay = createInsideDates()
            staysArray.appendContentsOf([insideStay])
            
            let count = datesCalculator!.countDaysWithinTheLastYearWithArray(staysArray)
            XCTAssertEqual(count, 3)
        }
    }
    
    
    
            func testDatesInside1(){
    
    
                let insideStay = createInsideDates1()
    
                staysArray.appendContentsOf([insideStay])
    
                let count = datesCalculator!.countDaysWithinTheLastYearWithArray(staysArray)
                XCTAssertEqual(count, 365)
            }
    
//            func testDatesInside1AllYear(){
//    
//                for _ in 1...fiveYears{
//                    initializeDates(1)
//                    staysArray.removeAll()
//    
//                    let insideStay = createInsideDates1()
//    
//                    staysArray.appendContentsOf([insideStay])
//    
//                    let count = datesCalculator!.countDaysWithinTheLastYearWithArray(staysArray)
//                    XCTAssertEqual(count, 365)
//                }
//            }
    
    
    
    //MARK: Left outside
    
    func testDatesLeftOutside(){
        //Left outside
        
        let leftOutside = createLeftOutsideDates()
        
        staysArray.appendContentsOf([leftOutside])
        
        let count = datesCalculator!.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 0)
        
    }
    
    func testDatesLeftOutsideAllYear(){
        
        for _ in 1...fiveYears{
            initializeDates(1)
            staysArray.removeAll()
            
            //Left outside
            
            let leftOutside = createLeftOutsideDates()
            
            staysArray.appendContentsOf([leftOutside])
            
            let count = datesCalculator!.countDaysWithinTheLastYearWithArray(staysArray)
            XCTAssertEqual(count, 0)
        }
    }
    
    
    //MARK: Right outside
    
    func testDatesRightOutside(){
        
        //Right outside
        
        let rightoutside =  createRightOutsideDates()
        
        staysArray.appendContentsOf([rightoutside])
        
        let count = datesCalculator!.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 0)
        
    }
    
    func testDatesRightOutsideAllYear(){
        
        for _ in 1...fiveYears{
            initializeDates(1)
            staysArray.removeAll()
            
            //Right outside
            
            let rightoutside =  createRightOutsideDates()
            
            staysArray.appendContentsOf([rightoutside])
            
            let count = datesCalculator!.countDaysWithinTheLastYearWithArray(staysArray)
            XCTAssertEqual(count, 0)
            
        }
    }
    
    
    //MARK: Left semi outside
    
    func testDatesSemiOutside1(){
        
        let semiOutside = createLeftSemiOutsideDates()
        
        staysArray.appendContentsOf([semiOutside])
        
        let count = datesCalculator!.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 3)
    }
    
    func testDatesSemiOutside1AllYear(){
        
        for _ in 1...fiveYears{
            initializeDates(1)
            staysArray.removeAll()
            
            let semiOutside = createLeftSemiOutsideDates()
            
            staysArray.appendContentsOf([semiOutside])
            
            let count = datesCalculator!.countDaysWithinTheLastYearWithArray(staysArray)
            XCTAssertEqual(count, 3)
        }
    }
    
    //MARK: Right semi outside
    
    func testDatesSemiOutside2(){
        
        let semiOutside = createRightSemiOutsideDates()
        staysArray.append(semiOutside)
        
        let count = datesCalculator!.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 3)
    }
    
    func testDatesSemiOutside2AllYear(){
        
        for _ in 1...fiveYears{
            initializeDates(1)
            staysArray.removeAll()
            
            let semiOutside = createRightSemiOutsideDates()
            staysArray.append(semiOutside)
            
            let count = datesCalculator!.countDaysWithinTheLastYearWithArray(staysArray)
            XCTAssertEqual(count, 3)
            
        }
    }
    
    //MARK: Date ranges
    
    
    //In order to create dates that fall inside the ranges rule, dates have to be within the following range:
    //Dates greater than today - 365 days (1 year ago)
    //Dates smaller than or equal to 31 dic last year
    
    
    
    
    
    func testInsideDatesRange(){
        
        //Testing with dates greater than 1 year ago
        
        let insideStay = createInsideDatesRange()
        
        staysArray.append(insideStay)
        
        let dateRangesArray = datesCalculator!.dateRangesWithArray(staysArray)
        
        if datesCalculator?.endDate.day != 31 && datesCalculator?.endDate.month != 12 {
            let firstElement = dateRangesArray.first!
            XCTAssertEqual(insideStay.dates.first, firstElement.dates.first!)
            XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
        }
        
        
    }
    
    
    func testInsideDatesRangeAllYear(){
        
        for _ in 1...fiveYears{
            initializeDates(1)
            staysArray.removeAll()
            
            //Testing with dates greater than 1 year ago
            
            let insideStay = createInsideDatesRange()
            
            staysArray.append(insideStay)
            
            let dateRangesArray = datesCalculator!.dateRangesWithArray(staysArray)
            
            if datesCalculator?.endDate.day != 31 && datesCalculator?.endDate.month != 12 {
                let firstElement = dateRangesArray.first!
                XCTAssertEqual(insideStay.dates.first, firstElement.dates.first!)
                XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
            }
        }
    }
    
    
    func testInsideDatesRange1(){
        
        //Testing with dates smaller or equal than 31 dic one year ago
        
        let insideStay = createInsideDatesRange1()
        
        staysArray.append(insideStay)
        let dateRangesArray = datesCalculator!.dateRangesWithArray(staysArray)
        
        /*
         Cases:
         endDate 31 Dec -> startDate 1 Jan therefore if inside stay contains dates lower or equal than 31 Dec, none of them should be added
         endDate 30 Dec -> startDate 31 Dec therefore if inside stay contains dates lower or equal than 31 Dec, only Dec 31 should be added
         */
        if (datesCalculator?.endDate.day == 31 && datesCalculator?.endDate.month == 12){
            XCTAssertEqual(0, dateRangesArray.count)
        }
        else if datesCalculator!.endDate.isInLeapYear()!{
            if (datesCalculator?.endDate.day == 30 && datesCalculator?.endDate.month == 12){
                XCTAssertEqual(0, dateRangesArray.count)
            }
            else if (datesCalculator?.endDate.day == 29 && datesCalculator?.endDate.month == 12){
                let firstElement = dateRangesArray.first!
                XCTAssertEqual(insideStay.dates.last, firstElement.dates.first!)
                XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
            }
        }
        else{
            if (datesCalculator?.endDate.day == 30 && datesCalculator?.endDate.month == 12){
                let firstElement = dateRangesArray.first!
                XCTAssertEqual(insideStay.dates.last, firstElement.dates.first!)
                XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
            }
            else{
                let firstElement = dateRangesArray.first!
                XCTAssertEqual(insideStay.dates.first, firstElement.dates.first!)
                XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
            }
        }
    }
    
    func testInsideDatesRange1AllYear(){
        
        for _ in 1...fiveYears{
            initializeDates(1)
            staysArray.removeAll()
            
            //Testing with dates smaller or equal than 31 dic one year ago
            
            let insideStay = createInsideDatesRange1()
            
            staysArray.append(insideStay)
            let dateRangesArray = datesCalculator!.dateRangesWithArray(staysArray)
            
            /*
             Cases:
             endDate 31 Dec -> startDate 1 Jan therefore if inside stay contains dates lower or equal than 31 Dec, none of them should be added
             endDate 30 Dec -> startDate 31 Dec therefore if inside stay contains dates lower or equal than 31 Dec, only Dec 31 should be added
             */
            if (datesCalculator?.endDate.day == 31 && datesCalculator?.endDate.month == 12){
                XCTAssertEqual(0, dateRangesArray.count)
            }
            else if datesCalculator!.endDate.isInLeapYear()!{
                if (datesCalculator?.endDate.day == 30 && datesCalculator?.endDate.month == 12){
                    XCTAssertEqual(0, dateRangesArray.count)
                }
                else if (datesCalculator?.endDate.day == 29 && datesCalculator?.endDate.month == 12){
                    let firstElement = dateRangesArray.first!
                    XCTAssertEqual(insideStay.dates.last, firstElement.dates.first!)
                    XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
                }
            }
            else{
                if (datesCalculator?.endDate.day == 30 && datesCalculator?.endDate.month == 12){
                    let firstElement = dateRangesArray.first!
                    XCTAssertEqual(insideStay.dates.last, firstElement.dates.first!)
                    XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
                }
                else{
                    let firstElement = dateRangesArray.first!
                    XCTAssertEqual(insideStay.dates.first, firstElement.dates.first!)
                    XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
                }
            }
        }
    }
    
    
        func testOutsideDatesRange(){
    
            //Testing with dates smaller or equal than 1 year ago
    
            let insideStay = createOutsideDatesRange()
    
            staysArray.append(insideStay)
    
            let dateRangesArray = datesCalculator!.dateRangesWithArray(staysArray)
            XCTAssertEqual(0, dateRangesArray.count)
        }
    
        func testOutsideDatesRangeAllYear(){
    
            for _ in 1...fiveYears{
                initializeDates(1)
                staysArray.removeAll()
    
                //Testing with dates smaller or equal than 1 year ago
    
                let insideStay = createOutsideDatesRange()
    
                staysArray.append(insideStay)
    
                let dateRangesArray = datesCalculator!.dateRangesWithArray(staysArray)
                XCTAssertEqual(0, dateRangesArray.count)
            }
        }

        func testOutsideDatesRange1(){
    
            //Testing with dates greater than 31 dic one year ago
    
            let insideStay = createOutsideDatesRange1()
    
            staysArray.append(insideStay)
    
            let dateRangesArray = datesCalculator!.dateRangesWithArray(staysArray)
            XCTAssertEqual(0, dateRangesArray.count)
            
        }
    
        func testOutsideDatesRange1AllYear(){
    
            for _ in 1...fiveYears{
                initializeDates(1)
                staysArray.removeAll()
    
                //Testing with dates greater than 31 dic one year ago
                
                let insideStay = createOutsideDatesRange1()
                
                staysArray.append(insideStay)
                
                let dateRangesArray = datesCalculator!.dateRangesWithArray(staysArray)
                XCTAssertEqual(0, dateRangesArray.count)
            }
        }
    
        func testSemiInsideDatesRange(){
    
            //Testing with dates that start smaller than 1 year ago and finish greater than one year ago
            
            var insideStay = createSemiInsideDatesRange()
            
            staysArray.append(insideStay)
            
            let dateRangesArray = datesCalculator!.dateRangesWithArray(staysArray)
            if (datesCalculator?.endDate.day == 31 && datesCalculator?.endDate.month == 12){
                XCTAssertEqual(0, dateRangesArray.count)
            }
            else if datesCalculator!.endDate.isInLeapYear()!{
                if datesCalculator?.endDate.day == 30 && datesCalculator?.endDate.month == 12{
                    XCTAssertEqual(0, dateRangesArray.count)
                }
                else if datesCalculator?.endDate.day == 29 && datesCalculator?.endDate.month == 12{
                    let firstElement = dateRangesArray.first!
                    XCTAssertEqual(firstElement.dates.first!, firstElement.dates.last!)
                }
                else {
                    let firstElement = dateRangesArray.first!
                    insideStay.dates.removeAtIndex(0)
                    XCTAssertEqual(insideStay.dates.first!, firstElement.dates.first!)
                    XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
                }
            }
            
            else if (datesCalculator?.endDate.day == 30 && datesCalculator?.endDate.month == 12){
                let firstElement = dateRangesArray.first!
                XCTAssertEqual(firstElement.dates.first!, firstElement.dates.last!)
            }
            else{
                let firstElement = dateRangesArray.first!
                XCTAssertEqual(datesCalculator!.startDate, firstElement.dates.first!)
                XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
            }
        }

    
        func testSemiInsideDatesRangeAllYear(){
            for _ in 1...fiveYears{
                initializeDates(1)
                staysArray.removeAll()
                
                //Testing with dates that start smaller than 1 year ago and finish greater than one year ago
                
                var insideStay = createSemiInsideDatesRange()
                
                staysArray.append(insideStay)
                
                let dateRangesArray = datesCalculator!.dateRangesWithArray(staysArray)
                if (datesCalculator?.endDate.day == 31 && datesCalculator?.endDate.month == 12){
                    XCTAssertEqual(0, dateRangesArray.count)
                }
                else if datesCalculator!.endDate.isInLeapYear()!{
                    if datesCalculator?.endDate.day == 30 && datesCalculator?.endDate.month == 12{
                        XCTAssertEqual(0, dateRangesArray.count)
                    }
                    else if datesCalculator?.endDate.day == 29 && datesCalculator?.endDate.month == 12{
                        let firstElement = dateRangesArray.first!
                        XCTAssertEqual(firstElement.dates.first!, firstElement.dates.last!)
                    }
                    else {
                        let firstElement = dateRangesArray.first!
                        insideStay.dates.removeAtIndex(0)
                        XCTAssertEqual(insideStay.dates.first!, firstElement.dates.first!)
                        XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
                    }
                }
                    
                else if (datesCalculator?.endDate.day == 30 && datesCalculator?.endDate.month == 12){
                    let firstElement = dateRangesArray.first!
                    XCTAssertEqual(firstElement.dates.first!, firstElement.dates.last!)
                }
                else{
                    let firstElement = dateRangesArray.first!
                    XCTAssertEqual(datesCalculator!.startDate, firstElement.dates.first!)
                    XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
                }
            }
        }
    
    
    
        func testSemiInsideDatesRange1(){
    
            //Testing with dates that start smaller than 31 dic one year ago and finish greater than 31 dic one year ago
    
            var insideStay = createSemiInsideDatesRange1()
    
            staysArray.append(insideStay)
    
            let dateRangesArray = datesCalculator!.dateRangesWithArray(staysArray)
            if (datesCalculator?.endDate.day == 31 && datesCalculator?.endDate.month == 12){
                XCTAssertEqual(0, dateRangesArray.count)
            }
            else if datesCalculator!.endDate.isInLeapYear()!{
                if (datesCalculator?.endDate.day == 30 && datesCalculator?.endDate.month == 12){
                   XCTAssertEqual(0, dateRangesArray.count)
                }
                else if (datesCalculator?.endDate.day == 29 && datesCalculator?.endDate.month == 12){
                    let firstElement = dateRangesArray.first!
                    insideStay.dates.removeAtIndex(0)
                    XCTAssertEqual(insideStay.dates.first!, firstElement.dates.first!)
                    XCTAssertEqual(firstElement.dates.first!, firstElement.dates.last!)
                }
            }
            else if (datesCalculator?.endDate.day == 30 && datesCalculator?.endDate.month == 12){
                    let firstElement = dateRangesArray.first!
                    insideStay.dates.removeAtIndex(0)
                    XCTAssertEqual(insideStay.dates.first!, firstElement.dates.first!)
                    XCTAssertEqual(firstElement.dates.first!, firstElement.dates.last!)
            
            }
            else{
                let firstElement = dateRangesArray.first!
                XCTAssertEqual(insideStay.dates.first!, firstElement.dates.first!)
                insideStay.dates.removeAtIndex(0)
                XCTAssertEqual(insideStay.dates.first!, firstElement.dates.last!)
            }
        }
    
        func testSemiInsideDatesRange1AllYear(){
    
            for _ in 1...fiveYears{
                initializeDates(1)
                staysArray.removeAll()
    
    
                //Testing with dates that start smaller than 31 dic one year ago and finish greater than 31 dic one year ago
                
                var insideStay = createSemiInsideDatesRange1()
                
                staysArray.append(insideStay)
                
                let dateRangesArray = datesCalculator!.dateRangesWithArray(staysArray)
                if (datesCalculator?.endDate.day == 31 && datesCalculator?.endDate.month == 12){
                    XCTAssertEqual(0, dateRangesArray.count)
                }
                else if datesCalculator!.endDate.isInLeapYear()!{
                    if (datesCalculator?.endDate.day == 30 && datesCalculator?.endDate.month == 12){
                        XCTAssertEqual(0, dateRangesArray.count)
                    }
                    else if (datesCalculator?.endDate.day == 29 && datesCalculator?.endDate.month == 12){
                        let firstElement = dateRangesArray.first!
                        insideStay.dates.removeAtIndex(0)
                        XCTAssertEqual(insideStay.dates.first!, firstElement.dates.first!)
                        XCTAssertEqual(firstElement.dates.first!, firstElement.dates.last!)
                    }
                }
                else if (datesCalculator?.endDate.day == 30 && datesCalculator?.endDate.month == 12){
                    let firstElement = dateRangesArray.first!
                    insideStay.dates.removeAtIndex(0)
                    XCTAssertEqual(insideStay.dates.first!, firstElement.dates.first!)
                    XCTAssertEqual(firstElement.dates.first!, firstElement.dates.last!)
                    
                }
                else{
                    let firstElement = dateRangesArray.first!
                    XCTAssertEqual(insideStay.dates.first!, firstElement.dates.first!)
                    insideStay.dates.removeAtIndex(0)
                    XCTAssertEqual(insideStay.dates.first!, firstElement.dates.last!)
                }
            }
        }
    
    //MARK: Test consolidatedDates
    
    func testConsolidatedCalculations(){
        
        //TODO: pensar una manera de cómo testear esto para todos los años como los demás tests.
        
        let staysArray = createStayInDifferentYears()
        
        let oldestDate = (datesCalculator!.endDate - 300.days).endOf(.Day)
        let upperBoundDate = NSDate().endOf(.Year).endOf(.Day)
        
        //Initialize datesCalculator with the oldest date entered by the user
        print(DateFormatHelper.stringFromDate(oldestDate))
        datesCalculator = DatesCalculatorHelper(endDate: oldestDate)
        
        let response = datesCalculator!.consolidatedCalculations(upperBoundDate, staysArray: staysArray)
        print(response)
        let yearResponse1 = response.first!
        let yearResponse2 = response.last!
        XCTAssertEqual(yearResponse1.flag, false)
        XCTAssertEqual(upperBoundDate.year - 1, yearResponse1.year)
        
        XCTAssertEqual(yearResponse2.flag, true)
        XCTAssertEqual(upperBoundDate.year , yearResponse2.year)
    }
    
    
    //MARK: Helper functions
    
    func createInsideDates() -> Stay{
        
        //Inside dates
        let inside1 = datesCalculator!.startDate + 15.days
        let inside2 = datesCalculator!.startDate + 16.days
        let inside3 = datesCalculator!.startDate + 17.days
        let insideStay = Stay(dates: [inside1, inside2, inside3])
        
        return insideStay
    }
    
    func createInsideDates1() -> Stay{
        
        //Create dates from today - 364
        
        var datesArray = Array<NSDate>()
        var counter = 0
        while counter < 366 {
            let date = datesCalculator!.startDate + counter.days
            datesArray.append(date)
            counter+=1
        }
        
        return Stay(dates: datesArray)
    }
    
    
    func createLeftOutsideDates() -> Stay{
        let outside1 = datesCalculator!.startDate - 1.days
        let outside2 = datesCalculator!.startDate - 2.days
        let outside3 = datesCalculator!.startDate - 3.days
        
        return Stay(dates: [outside1, outside2, outside3])
    }
    
    func createRightOutsideDates() -> Stay{
        let outside1 = datesCalculator!.endDate + 1.days
        let outside2 = datesCalculator!.endDate + 2.days
        let outside3 = datesCalculator!.endDate + 3.days
        
        return Stay(dates: [outside1, outside2, outside3])
    }
    
    //Ranges Dates
    
    func createLeftSemiOutsideDates() -> Stay{
        
        let outside1 = datesCalculator!.startDate - 1.days
        let outside2 = datesCalculator!.startDate - 2.days
        let outside3 = datesCalculator!.startDate - 3.days
        
        let inside = datesCalculator!.startDate
        let inside1 = datesCalculator!.startDate + 1.days
        let inside2 = datesCalculator!.startDate + 2.days
        
        return Stay(dates: [outside3, outside2, outside1,inside, inside1, inside2])
    }
    
    func createRightSemiOutsideDates() -> Stay{
        
        let inside = datesCalculator!.endDate - 2.days
        let inside1 = datesCalculator!.endDate - 1.days
        let inside2 = datesCalculator!.endDate
        
        let outside = datesCalculator!.endDate + 1.days
        let outside1 = datesCalculator!.endDate + 2.days
        let outside2 = datesCalculator!.endDate + 3.days
        
        return Stay(dates: [inside, inside1, inside2, outside, outside1, outside2])
    }
    
    //Ranges Dates
    
    func createInsideDatesRange() -> Stay{
        
        let startDate = datesCalculator!.startDate
        
        let inside1 = startDate
        let inside2 = startDate + 1.days
        let inside3 = startDate + 2.days
        
        return Stay(dates: [ inside1, inside2, inside3])
        
    }
    
    func createOutsideDatesRange() -> Stay{
        
        let startDate = datesCalculator!.startDate
        
        let outside1 = startDate - 1.days
        let outside2 = startDate - 2.days
        let outside3 = startDate - 3.days
        
        return Stay(dates: [ outside3, outside2, outside1])
    }
    
    func createSemiInsideDatesRange() -> Stay{
        
        let startDate = datesCalculator!.startDate
        
        
        let date1 = startDate - 1.days
        let date2 = startDate
        let date3 = startDate + 1.days
        
        return Stay(dates: [date1,date2, date3])
    }
    
    func createInsideDatesRange1() -> Stay{
        let startDate = (datesCalculator!.endDate - 1.years).endOf(.Year)
        
        
        
        let inside1 = startDate - 1.days
        let inside2 = startDate
        
        return Stay(dates: [inside1, inside2, ])
    }
    
    func createOutsideDatesRange1() -> Stay{
        
        let startDate = (datesCalculator!.endDate - 1.years).endOf(.Year).endOf(.Day)
        let outside = startDate + 1.days
        let outside1 = startDate + 2.days
        
        return Stay(dates: [ outside, outside1])
    }
    
    func createSemiInsideDatesRange1() -> Stay{
        
        let startDate = (datesCalculator!.endDate - 1.years).endOf(.Year).endOf(.Day)
        
        let date1 = startDate - 1.days
        let date2 = startDate
        let date3 = startDate + 1.days
        
        
        return Stay(dates: [date1,date2, date3])
    }
    
    func createStayInDifferentYears() -> [Stay]{
        
        var datesArray1 = Array<NSDate>()
        //This would add elements from 0-99
        for i in 0..<100{
            let date = (datesCalculator!.endDate - 300.days + i.days).endOf(.Day)
            datesArray1.append(date)
        }
        
        var datesArray2 = Array<NSDate>()
        for i in 0..<100{
            let date = (datesCalculator!.endDate - 150.days + i.days).endOf(.Day)
            datesArray2.append(date)
        }
        return [Stay(dates: datesArray1), Stay(dates: datesArray2)]
    }
}
