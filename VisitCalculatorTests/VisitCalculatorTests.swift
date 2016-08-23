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
    
    func testInsideDatesRange(){
        
        let insideStay = createInsideDates()
        
        staysArray.append(insideStay)
        
        let dateRangesArray = DatesCalculatorHelper.dateRangesWithArray(staysArray)
        let firstElement = dateRangesArray.first!
        XCTAssertEqual(insideStay.dates.first, firstElement.dates.first!)
        XCTAssertEqual(insideStay.dates.last!, firstElement.dates.last!)
        
        
        
    }
    
    
    func testOutsideDatesRange1(){
        
        let outsideStay = createLeftOutsideDates()
        
        staysArray.append(outsideStay)
        
        let dateRangesArray = DatesCalculatorHelper.dateRangesWithArray(staysArray)
        XCTAssertEqual(0, dateRangesArray.count)
        
    }
    
    func testOutsideDatesRange2(){
        
        let outsideStay = createRightOutsideDates()
        
        staysArray.append(outsideStay)
        
        let dateRangesArray = DatesCalculatorHelper.dateRangesWithArray(staysArray)
        XCTAssertEqual(0, dateRangesArray.count)
        
    }
    
    
    func testSemiOutsideDatesRange1(){
        
        let semiOutsideStay = createLeftSemiOutsideDates()
        
        staysArray.append(semiOutsideStay)
        let dateRangesArray = DatesCalculatorHelper.dateRangesWithArray(staysArray)
        let firstElement = dateRangesArray.first!
        print(DateFormatHelper.mediumDate().stringFromDate(firstElement.dates.first!))
        print(DateFormatHelper.mediumDate().stringFromDate(firstElement.dates.last!))
        XCTAssertEqual(beginingDate!, firstElement.dates.first!)
        XCTAssertEqual(semiOutsideStay.dates.last!, firstElement.dates.last!)
        
    }
    
    func testSemiOutsideDatesRange2(){
        
        let semiOutsideStay = createRightSemiOutsideDates()
        
        staysArray.append(semiOutsideStay)
        let dateRangesArray = DatesCalculatorHelper.dateRangesWithArray(staysArray)
        let firstElement = dateRangesArray.first!
        print(DateFormatHelper.mediumDate().stringFromDate(firstElement.dates.first!))
        print(DateFormatHelper.mediumDate().stringFromDate(firstElement.dates.last!))
        XCTAssertEqual(semiOutsideStay.dates.first!, firstElement.dates.first!)
        XCTAssertEqual(firstElement.dates.last!, endDate!)
        
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

}
