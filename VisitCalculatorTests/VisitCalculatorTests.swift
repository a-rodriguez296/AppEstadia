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
    

    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    
    func testDatesInside(){
        
        //Inside dates
        let inside1 = beginingDate! + 15.days
        let inside2 = beginingDate! + 16.days
        let inside3 = beginingDate! + 17.days
        let insideStay = Stay(dates: [inside1, inside2, inside3])
        
        staysArray.appendContentsOf([insideStay])
        
        let count = DatesCalculatorHelper.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 3)
        
        
    }
    
    func testDatesInside1(){
        
        //Inside dates
        
        //Test the entire year
        
        var datesArray = Array<NSDate>()
        var counter = 0
        while counter < 365 {
            datesArray.append(beginingDate! + counter.days)
            counter+=1
        }
        
        
        let insideStay = Stay(dates: datesArray)
        
        staysArray.appendContentsOf([insideStay])
        
        let count = DatesCalculatorHelper.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 365)

        
    }
    
    
    func testDatesLeftOutside(){
        //Left outside
        
        let outside1 = beginingDate! - 1.days
        let outside2 = beginingDate! - 2.days
        let outside3 = beginingDate! - 3.days
        
        let leftOutside = Stay(dates: [outside1, outside2, outside3])
        
        staysArray.appendContentsOf([leftOutside])
        
        let count = DatesCalculatorHelper.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 0)
        
    }
    
    
    func testDatesRightOutside(){
        
        //Right outside
        
        let outside1 = endDate! + 1.days
        let outside2 = endDate! + 2.days
        let outside3 = endDate! + 3.days
        
        let rightoutside = Stay(dates: [outside1, outside2, outside3])
        
        staysArray.appendContentsOf([rightoutside])
        
        let count = DatesCalculatorHelper.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 0)
        
    }
    
    
    func testDatesSemiOutside1(){
        
        let outside1 = beginingDate! - 1.days
        let outside2 = beginingDate! - 2.days
        let outside3 = beginingDate! - 3.days
        
        let inside = beginingDate!
        let inside1 = beginingDate! + 1.days
        let inside2 = beginingDate! + 2.days
        
        let semiOutside = Stay(dates: [outside3, outside2, outside1,inside, inside1, inside2])
        
        staysArray.appendContentsOf([semiOutside])
        
        let count = DatesCalculatorHelper.countDaysWithinTheLastYearWithArray(staysArray)
        XCTAssertEqual(count, 3)
    }
    
}
