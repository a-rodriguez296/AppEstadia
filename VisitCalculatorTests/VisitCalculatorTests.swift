//
//  VisitCalculatorTests.swift
//  VisitCalculatorTests
//
//  Created by Alejandro Rodriguez on 8/23/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import XCTest
import SwiftDate

class VisitCalculatorTests: XCTestCase {
    
    var beginingDate:NSDate?
    var endDate:NSDate?
    var staysArray = Array<Stay>()
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        beginingDate =  DatesCalculatorHelper.beginingDate
        endDate = DatesCalculatorHelper.endDate
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        staysArray = Array<Stay>()
    }
    
    
    //MARK: Days within year
    
    //MARK: Inside dates
    
    func testDatesInside(){
        
        let insideStay = createInsideDates()
        
        staysArray.appendContentsOf([insideStay])
        
        let count = DatesCalculatorHelper.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 3)
    }
    
    
    func testDatesInside1(){
        
        
        let insideStay = createInsideDates1()
        
        staysArray.appendContentsOf([insideStay])
        
        let count = DatesCalculatorHelper.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 365)
        
    }
    
    //MARK: Left outside
    
    func testDatesLeftOutside(){
        //Left outside
        
        let leftOutside = createLeftOutsideDates()
        
        staysArray.appendContentsOf([leftOutside])
        
        let count = DatesCalculatorHelper.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 0)
        
    }
    
    //MARK: Right outside
    
    func testDatesRightOutside(){
        
        //Right outside
        
        let rightoutside =  createRightOutsideDates()
        
        staysArray.appendContentsOf([rightoutside])
        
        let count = DatesCalculatorHelper.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 0)
        
    }
    
    
    //MARK: Left semi outside
    
    func testDatesSemiOutside1(){
        
        let semiOutside = createLeftSemiOutsideDates()
        
        staysArray.appendContentsOf([semiOutside])
        
        let count = DatesCalculatorHelper.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 3)
    }
    
    //MARK: Right semi outside
    
    func testDatesSemiOutside2(){
        
        let semiOutside = createRightSemiOutsideDates()
        staysArray.append(semiOutside)
        
        let count = DatesCalculatorHelper.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 3)
    }
    
    //MARK: Date ranges
    
    
    //In order to create dates that fall inside the ranges rule, dates have to be within the following range:
    //Dates greater than today - 365 days (1 year ago)
    //Dates smaller than or equal to 31 dic last year
    
    
    
    
    
    func testInsideDatesRange(){
        
        //Testing with dates greater than 1 year ago
        
        let insideStay = createInsideDatesRange()
        
        staysArray.append(insideStay)
        
        let dateRangesArray = DatesCalculatorHelper.dateRangesWithArray(staysArray)
        let firstElement = dateRangesArray.first!
        XCTAssertEqual(insideStay.dates.first, firstElement.dates.first!)
        XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
        
    }
    
    
    func testInsideDatesRange1(){
        
        //Testing with dates smaller or equal than 31 dic one year ago
        
        let insideStay = createInsideDatesRange1()
        
        staysArray.append(insideStay)
        
        let dateRangesArray = DatesCalculatorHelper.dateRangesWithArray(staysArray)
        let firstElement = dateRangesArray.first!
        XCTAssertEqual(insideStay.dates.first, firstElement.dates.first!)
        XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
    }
    
    
    func testOutsideDatesRange(){
        
        //Testing with dates smaller or equal than 1 year ago
        
        let insideStay = createOutsideDatesRange()
        
        staysArray.append(insideStay)
        
        let dateRangesArray = DatesCalculatorHelper.dateRangesWithArray(staysArray)
        XCTAssertEqual(0, dateRangesArray.count)
    }
    
    func testOutsideDatesRange1(){
        
        //Testing with dates greater than 31 dic one year ago
        
        let insideStay = createOutsideDatesRange1()
        
        staysArray.append(insideStay)
        
        let dateRangesArray = DatesCalculatorHelper.dateRangesWithArray(staysArray)
        XCTAssertEqual(0, dateRangesArray.count)
    }
    
    func testSemiInsideDatesRange(){
        
        //Testing with dates that start smaller than 1 year ago and finish greater than one year ago
        
        let insideStay = createSemiInsideDatesRange()
        
        staysArray.append(insideStay)
        
        let dateRangesArray = DatesCalculatorHelper.dateRangesWithArray(staysArray)
        let firstElement = dateRangesArray.first!
        XCTAssertEqual(beginingDate!, firstElement.dates.first!)
        XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
        
        
    }
    
    
    func testSemiInsideDatesRange1(){
        
        //Testing with dates that start smaller than 31 dic one year ago and finish greater than 31 dic one year ago
        
        let insideStay = createSemiInsideDatesRange1()
        
        staysArray.append(insideStay)
        
        let dateRangesArray = DatesCalculatorHelper.dateRangesWithArray(staysArray)
        let firstElement = dateRangesArray.first!
        XCTAssertEqual(insideStay.dates.first!, firstElement.dates.first!)
        XCTAssertEqual((1.years.ago).endOf(.Year), firstElement.dates.last!)
    }
    
    //MARK: Helper functions
    
    func createInsideDates() -> Stay{
        
        //Inside dates
        let inside1 = beginingDate! + 15.days
        let inside2 = beginingDate! + 16.days
        let inside3 = beginingDate! + 17.days
        let insideStay = Stay(dates: [inside1, inside2, inside3])
        
        return insideStay
    }
    
    func createInsideDates1() -> Stay{
        
        //Create dates from today - 364
        
        var datesArray = Array<NSDate>()
        var counter = 0
        while counter < 365 {
            datesArray.append(beginingDate! + counter.days)
            counter+=1
        }
        
        return Stay(dates: datesArray)
    }
    
    
    func createLeftOutsideDates() -> Stay{
        let outside1 = beginingDate! - 1.days
        let outside2 = beginingDate! - 2.days
        let outside3 = beginingDate! - 3.days
        
        return Stay(dates: [outside1, outside2, outside3])
    }
    
    func createRightOutsideDates() -> Stay{
        let outside1 = endDate! + 1.days
        let outside2 = endDate! + 2.days
        let outside3 = endDate! + 3.days
        
        return Stay(dates: [outside1, outside2, outside3])
    }
    
    //Ranges Dates
    
    func createLeftSemiOutsideDates() -> Stay{
        
        let outside1 = beginingDate! - 1.days
        let outside2 = beginingDate! - 2.days
        let outside3 = beginingDate! - 3.days
        
        let inside = beginingDate!
        let inside1 = beginingDate! + 1.days
        let inside2 = beginingDate! + 2.days
        
        return Stay(dates: [outside3, outside2, outside1,inside, inside1, inside2])
    }
    
    func createRightSemiOutsideDates() -> Stay{
        
        let inside = endDate! - 2.days
        let inside1 = endDate! - 1.days
        let inside2 = endDate!
        
        let outside = endDate! + 1.days
        let outside1 = endDate! + 2.days
        let outside2 = endDate! + 3.days
        
        return Stay(dates: [inside, inside1, inside2, outside, outside1, outside2])
    }
    
    //Ranges Dates
    
    func createInsideDatesRange() -> Stay{
        
        let startDate = beginingDate!
        
        let inside1 = startDate
        let inside2 = startDate + 1.days
        let inside3 = startDate + 2.days
        
        return Stay(dates: [ inside1, inside2, inside3])
        
    }
    
    func createOutsideDatesRange() -> Stay{
        
        let startDate = beginingDate!
        
        let outside1 = startDate - 1.days
        let outside2 = startDate - 2.days
        let outside3 = startDate - 3.days
        
        return Stay(dates: [ outside3, outside2, outside1])
    }
    
    func createSemiInsideDatesRange() -> Stay{
        
        let startDate = beginingDate!
        
        let date1 = startDate - 3.days
        let date2 = startDate - 2.days
        let date3 = startDate + 1.days
        let date4 = startDate
        let date5 = startDate + 1.days
        let date6 = startDate + 2.days
        
        return Stay(dates: [date1,date2, date3, date4, date5, date6])
    }
    
    func createInsideDatesRange1() -> Stay{
        let startDate = (1.years.ago).endOf(.Year)
        
        let inside = startDate - 3.days
        let inside1 = startDate - 2.days
        let inside2 = startDate - 1.days
        
        return Stay(dates: [inside, inside1, inside2])
    }
    
    func createOutsideDatesRange1() -> Stay{
        
        let startDate = (1.years.ago).endOf(.Year)
        
        let outside = startDate
        let outside1 = startDate + 1.days
        let outside2 = startDate + 2.days
        
        return Stay(dates: [ outside, outside1, outside2])
    }
    
    func createSemiInsideDatesRange1() -> Stay{
        
        let startDate = (1.years.ago).endOf(.Year)
        
        let date1 = startDate - 3.days
        let date2 = startDate - 2.days
        let date3 = startDate - 1.days
        let date4 = startDate
        let date5 = startDate + 1.days
        let date6 = startDate + 2.days
        
        return Stay(dates: [date1,date2, date3, date4, date5, date6])
    }
}
