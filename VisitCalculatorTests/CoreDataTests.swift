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
    
    var taxPayer:CDTaxPayer?
    let colombiaCountryCode = "CO"
    let usaCountryCode = "US"
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        setupCoreData()
        taxPayer = CDTaxPayer(name: "Alejandro", id: "123123123", context: NSManagedObjectContext.MR_defaultContext())
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        tearDownCoreData()
    }
    
    func testAddDate (){
        
        let _ = CDDate(date: NSDate().endOf(.Day),taxPayer: taxPayer!, context: NSManagedObjectContext.MR_defaultContext())
        let _ = CDDate(date: (NSDate() - 1.days).endOf(.Day),taxPayer: taxPayer!, context: NSManagedObjectContext.MR_defaultContext())
        NSManagedObjectContext.MR_defaultContext().MR_saveOnlySelfAndWait()
        
        XCTAssertTrue(2 == CDDate.MR_findAll()!.count)
        
    }
    
    
    func testAddStay(){
        
        let _ = CDStay(dates: [NSDate().endOf(.Day)],taxPayer: taxPayer!,countryCode: colombiaCountryCode, stayType: true, context: NSManagedObjectContext.MR_defaultContext())
        let _ = CDStay(dates: [(NSDate() - 1.days).endOf(.Day)],taxPayer: taxPayer! ,countryCode: colombiaCountryCode,stayType: true, context: NSManagedObjectContext.MR_defaultContext())
        NSManagedObjectContext.MR_defaultContext().MR_saveOnlySelfAndWait()
        
        XCTAssertTrue(2 == CDStay.MR_findAll()!.count)
    }
}

//MARK: Helper functions

//////////////////////////////////////////////
// HELPER FUNCTIONS
//////////////////////////////////////////////

private func generateDates0() -> Array<NSDate>{
    
    var datesArray = Array<NSDate>()
    for i in 0...10 {
        
        let date = (NSDate() - i.days).endOf(.Day)
        datesArray.append(date)
    }
    return datesArray.reverse()
}

private func generateDates1() -> Array<NSDate>{
    var datesArray = Array<NSDate>()
    
    
    for i in 11...20 {
        
        let date = (NSDate() - i.days).endOf(.Day)
        datesArray.append(date)
    }
    return datesArray.reverse()
}




extension CoreDataTests{
    
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
