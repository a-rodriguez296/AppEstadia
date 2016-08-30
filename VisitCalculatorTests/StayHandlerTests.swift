//
//  StayHandlerTests.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/30/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import XCTest
import SwiftDate

class StayHandlerTests: XCTestCase {

    var stayHandler:StayHandler?
    
    override func setUp() {
        super.setUp()
        stayHandler = StayHandler.sharedInstance
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
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
    
    func testAddRepeatedDates(){
        
        
        let stay = createStay()
        
        stayHandler!.addStay(stay)
        
        let repeatedStay = createRepeatedStay()
        
        let repeatedDate = stayHandler!.addStay(repeatedStay)
        XCTAssertEqual(repeatedDate, NSDate().endOf(.Day).endOf(.Day))
    }
    
    func testAddRepeatedDates1(){
        
        
        let stay = createStay()
        
        stayHandler!.addStay(stay)
        
        let repeatedStay = createRepeatedStay()
        
        stayHandler!.addStay(repeatedStay)
        
        XCTAssertEqual(3, stayHandler?.datesCount())
    }
    
    
    
    private func createStay() -> Stay{
        
        let date1 = NSDate().endOf(.Day).endOf(.Day)
        let date2 = NSDate().endOf(.Day).endOf(.Day) - 1.days
        let date3 = NSDate().endOf(.Day).endOf(.Day) - 3.days
        
        return Stay(dates: [date1, date2, date3])
    }
    
    private func createRepeatedStay() -> Stay{
        
        let date1 = NSDate().endOf(.Day).endOf(.Day)
        let date2 = NSDate().endOf(.Day).endOf(.Day) + 1.days
        let date3 = NSDate().endOf(.Day).endOf(.Day) + 3.days
        
        return Stay(dates: [date1, date2, date3])
    }
}
