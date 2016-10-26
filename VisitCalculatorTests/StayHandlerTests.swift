//
//  StayHandlerTests.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/30/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import XCTest
import SwiftDate


@testable import VisitCalculator
class StayHandlerTests: XCTestCase {
    
    var stayHandler:StayHandler?
    
    override func setUp() {
        super.setUp()
        stayHandler = StayHandler.sharedInstance
    }
    
    override func tearDown() {
        super.tearDown()
        stayHandler!.dumpStays()
        stayHandler = nil
    }
    
    func testAddDates(){
        
        let stay = createStay()
        
        let flag = stayHandler!.addStay(stay)
        XCTAssertNil(flag)
    }
    
    func testAddDates1(){
        
        let stay = createStay()
        
        stayHandler!.addStay(stay)
        XCTAssertEqual(3,stayHandler!.datesCount())
    }
    
    func testAddDates2(){
        let stay = createStay()
        
        stayHandler!.addStay(stay)
        XCTAssertEqual(1,stayHandler!.staysCount())
    }
    
    func testAddRepeatedDates(){
        
        
        let stay = createStay()
        stayHandler!.addStay(stay)
        
        let repeatedStay = createRepeatedStay()
        let repeatedDate = stayHandler!.addStay(repeatedStay)
        XCTAssertEqual(repeatedDate, Date().endOf(.Day).endOf(.Day))
    }
    
    func testAddRepeatedDates1(){
        
        
        let stay = createStay()
        stayHandler!.addStay(stay)
        
        let repeatedStay = createRepeatedStay()
        stayHandler!.addStay(repeatedStay)
        XCTAssertEqual(3, stayHandler?.datesCount())
    }
    
    func testAddRepeatedDates2(){
        
        
        let stay = createStay()
        stayHandler!.addStay(stay)
        
        let repeatedStay = createRepeatedStay()
        stayHandler!.addStay(repeatedStay)
        XCTAssertEqual(1, stayHandler?.staysCount())
    }
    
    
    func testAddSeveralStays(){
        
        let staysArray = createStaysArray()
        
        for stay in staysArray {
            stayHandler!.addStay(stay)
        }
        XCTAssertEqual(staysArray.count * 3,stayHandler!.datesCount())
    }
    
    func testAddSeveralStays1(){
        
        let staysArray = createStaysArray()
        
        for stay in staysArray {
            stayHandler!.addStay(stay)
        }
        XCTAssertEqual(staysArray.count,stayHandler!.staysCount())
    }
    
    func testAddSeveralStays2(){
        /*
         This test is for checking the order of staysArray
         
         The correct order should be:
         [1], [2], [3], [0]
         */
        let staysArray = createStaysArray()
        for stay in staysArray {
            stayHandler!.addStay(stay)
        }
        
        let orderedArray = stayHandler!.staysArray()
        
        XCTAssertEqual(staysArray[1],orderedArray[0])
        XCTAssertEqual(staysArray[2],orderedArray[1])
        XCTAssertEqual(staysArray[3],orderedArray[2])
        XCTAssertEqual(staysArray[0],orderedArray[3])
    }
    
    func testAddSeveralStays3(){
        /*
         This test is for checking that staysArray does not contain repeated dates
         */
        let staysArray = createStaysArray1()
        for stay in staysArray {
            stayHandler!.addStay(stay)
        }
        
        let orderedArray = stayHandler!.staysArray()
        for stay in orderedArray {
            stayHandler!.addStay(stay)
        }
        XCTAssertEqual(3,orderedArray.count)
    }
    
    func testAddSeveralStays4(){
        /*
         This test is for checking that staysArray does not contain repeated dates
         */
        let staysArray = createStaysArray1()
        for stay in staysArray {
            stayHandler!.addStay(stay)
        }
        
        let orderedArray = stayHandler!.staysArray()
        for stay in orderedArray {
            stayHandler!.addStay(stay)
        }
        XCTAssertEqual(staysArray[1],orderedArray[0])
        XCTAssertEqual(staysArray[3],orderedArray[1])
        XCTAssertEqual(staysArray[0],orderedArray[2])
    }
    
    func testDeleteStay(){
        
        let stay = createStay()
        
        stayHandler!.addStay(stay)
        stayHandler!.deleteStayWithIndex(0)
        XCTAssertEqual(0,stayHandler!.datesCount())
    }

    func testDeleteStay1(){
        
        let stay = createStay()
        
        stayHandler!.addStay(stay)
        stayHandler!.deleteStayWithIndex(0)
        XCTAssertEqual(0,stayHandler!.staysCount())
    }
    
    
    func testDeleteStay2(){
        
        /*
         This test is for checking the order of staysArray
         
        */
        let staysArray = createStaysArray()
        for stay in staysArray {
            stayHandler!.addStay(stay)
        }
        stayHandler!.deleteStayWithIndex(2)
        
        let orderedArray = stayHandler!.staysArray()
        
        XCTAssertEqual(staysArray[1],orderedArray[0])
        XCTAssertEqual(staysArray[2],orderedArray[1])
        XCTAssertEqual(staysArray[0],orderedArray[2])
    }
    
    func testOldestDate(){
        
        let staysArray = createStaysArray2()
        for stay in staysArray {
            stayHandler!.addStay(stay)
        }

        let oldestDate = stayHandler!.oldestDate()
        
        //This is the date I know is the oldest date
        let knownOldestDate = Date().endOf(.Day) - 72.days
        
        XCTAssertEqual(knownOldestDate, oldestDate)
    }
    
    //MARK: Helper functions
    
    //////////////////////////////////////////////
    // HELPER FUNCTIONS
    //////////////////////////////////////////////
    
    fileprivate func createStay() -> Stay{
        
        let date1 = Date().endOf(.Day).endOf(.Day)
        let date2 = Date().endOf(.Day).endOf(.Day) - 1.days
        let date3 = Date().endOf(.Day).endOf(.Day) - 2.days
        
        return Stay(dates: [date1, date2, date3])
    }
    
    fileprivate func createRepeatedStay() -> Stay{
        
        let date1 = Date().endOf(.Day).endOf(.Day)
        let date2 = Date().endOf(.Day).endOf(.Day) + 1.days
        let date3 = Date().endOf(.Day).endOf(.Day) + 2.days
        
        return Stay(dates: [date1, date2, date3])
    }
    
    
    fileprivate func createStaysArray() -> [Stay]{
        
        let date1 = Date().endOf(.Day).endOf(.Day) - 2.days
        let date2 = Date().endOf(.Day).endOf(.Day) - 1.days
        let date3 = Date().endOf(.Day).endOf(.Day)
        
        let stay1 = Stay(dates: [date1, date2, date3])
        
        let date4 = Date().endOf(.Day).endOf(.Day) - 72.days
        let date5 = Date().endOf(.Day).endOf(.Day) - 71.days
        let date6 = Date().endOf(.Day).endOf(.Day) - 70.days
        
        let stay2 = Stay(dates: [date4,date5,date6])
        
        let date7 = Date().endOf(.Day).endOf(.Day) - 22.days
        let date8 = Date().endOf(.Day).endOf(.Day) - 21.days
        let date9 = Date().endOf(.Day).endOf(.Day) - 20.days
        
        let stay3 = Stay(dates: [date7, date8, date9])
        
        let date10 = Date().endOf(.Day).endOf(.Day) - 12.days
        let date11 = Date().endOf(.Day).endOf(.Day) - 11.days
        let date12 = Date().endOf(.Day).endOf(.Day) - 10.days
        
        let stay4 = Stay(dates: [date10, date11, date12])
        
        return [stay1, stay2, stay3, stay4]
    }
    
    fileprivate func createStaysArray1() -> [Stay]{
        
        let date1 = Date().endOf(.Day).endOf(.Day) - 2.days
        let date2 = Date().endOf(.Day).endOf(.Day) - 1.days
        let date3 = Date().endOf(.Day).endOf(.Day)
        
        let stay1 = Stay(dates: [date1, date2, date3])
        
        let date4 = Date().endOf(.Day).endOf(.Day) - 72.days
        let date5 = Date().endOf(.Day).endOf(.Day) - 71.days
        let date6 = Date().endOf(.Day).endOf(.Day) - 70.days
        
        let stay2 = Stay(dates: [date4,date5,date6])
        
        let date7 = Date().endOf(.Day).endOf(.Day) - 4.days
        let date8 = Date().endOf(.Day).endOf(.Day) - 3.days
        let date9 = Date().endOf(.Day).endOf(.Day) - 2.days
        
        let stay3 = Stay(dates: [date7, date8, date9])
        
        let date10 = Date().endOf(.Day).endOf(.Day) - 12.days
        let date11 = Date().endOf(.Day).endOf(.Day) - 11.days
        let date12 = Date().endOf(.Day).endOf(.Day) - 10.days
        
        let stay4 = Stay(dates: [date10, date11, date12])
        
        return [stay1, stay2, stay3, stay4]
    }
    
    fileprivate func createStaysArray2() ->[Stay]{
        
        let date1 = Date().endOf(.Day).endOf(.Day) - 2.days
        let date2 = Date().endOf(.Day).endOf(.Day) - 1.days
        let date3 = Date().endOf(.Day).endOf(.Day)
        
        let stay1 = Stay(dates: [date1, date2, date3])
        
        let date4 = Date().endOf(.Day).endOf(.Day) - 72.days
        let date5 = Date().endOf(.Day).endOf(.Day) - 71.days
        let date6 = Date().endOf(.Day).endOf(.Day) - 70.days
        
        let stay2 = Stay(dates: [date4,date5,date6])
        
        let date7 = Date().endOf(.Day).endOf(.Day) - 4.days
        let date8 = Date().endOf(.Day).endOf(.Day) - 3.days
        let date9 = Date().endOf(.Day).endOf(.Day) - 2.days
        
        let stay3 = Stay(dates: [date7, date8, date9])
        
        let date10 = Date().endOf(.Day).endOf(.Day) - 12.days
        let date11 = Date().endOf(.Day).endOf(.Day) - 11.days
        let date12 = Date().endOf(.Day).endOf(.Day) - 10.days
        
        let stay4 = Stay(dates: [date10, date11, date12])
        
        return [stay2, stay3, stay1, stay4]
        
    }
    
}
