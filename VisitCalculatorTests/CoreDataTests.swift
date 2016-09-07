//
//  CoreDataTests.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/6/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import XCTest
import MagicalRecord
import SwiftDate


@testable import VisitCalculator
class CoreDataTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setupCoreData()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        tearDownCoreData()
    }
    
    func testAddDate (){
        
        let _ = CDDate(date: NSDate().endOf(.Day), context: NSManagedObjectContext.MR_defaultContext())
        let _ = CDDate(date: (NSDate() - 1.days).endOf(.Day), context: NSManagedObjectContext.MR_defaultContext())
        NSManagedObjectContext.MR_defaultContext().MR_saveOnlySelfAndWait()
        
        XCTAssertTrue(2 == CDDate.MR_findAll()!.count)
        
    }
    
    
    func testAddStay(){
        
        let _ = CDStay(dates: [NSDate().endOf(.Day)], context: NSManagedObjectContext.MR_defaultContext())
        let _ = CDStay(dates: [(NSDate() - 1.days).endOf(.Day)], context: NSManagedObjectContext.MR_defaultContext())
        NSManagedObjectContext.MR_defaultContext().MR_saveOnlySelfAndWait()
        
        XCTAssertTrue(2 == CDStay.MR_findAll()!.count)
    }
    
    
    
    func testWithNonExistingDates() {
        
        //this test assumes the application does not have any CDDate stored. Therefore the method verifyDates should respond true
        
        let datesArray = generateDates()
        
        let flag = CDDate.verifyDates(datesArray)
        XCTAssertNil(flag)
    }
    
    func testAddingRepeatedDates(){
        
        let _ = CDDate(date: NSDate().endOf(.Day), context: NSManagedObjectContext.MR_defaultContext())
        NSManagedObjectContext.MR_defaultContext().MR_saveOnlySelfAndWait()
        let flag = CDDate.verifyDates([NSDate().endOf(.Day)])
        XCTAssertEqual(flag, NSDate().endOf(.Day))
        
    }
    
}

//MARK: Helper functions

//////////////////////////////////////////////
// HELPER FUNCTIONS
//////////////////////////////////////////////

private func generateDates() -> Array<NSDate>{
    
    
    var datesArray = Array<NSDate>()
    
    
    for i in 0...10 {
        
        let date = (NSDate() - i.days).endOf(.Day)
        datesArray.append(date)
    }
    return datesArray
}


extension XCTestCase{
    
    func setupCoreData () {
        // Cleanup Core Data setup because there already is a context setup in the
        // AppDelegate. We do not want to use this context and therefore we create
        // an in memory one.
        MagicalRecord.cleanUp()
        MagicalRecord.setupCoreDataStackWithInMemoryStore()
    }
    
    func tearDownCoreData () {
        MagicalRecord.cleanUp()
    }
}
