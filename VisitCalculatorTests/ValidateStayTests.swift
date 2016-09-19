//
//  ValidateStayTests.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/19/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import XCTest
import MagicalRecord
import SwiftDate

@testable import VisitCalculator
class ValidateStayTests: XCTestCase {
    
    var taxPayer:CDTaxPayer?
    let colombiaCountryCode = "CO"
    let usaCountryCode = "US"
    
    override func setUp() {
        super.setUp()
        
        setupCoreData()
        taxPayer = CDTaxPayer(name: "Alejandro", id: "123123123", context: NSManagedObjectContext.MR_defaultContext())
    }
    
    override func tearDown() {
        super.tearDown()
        
        tearDownCoreData()
    }
    
    //MARK: Adding dates with different countries
    
    func testAddNonOverlapingDates(){
        
        let dates0 = generateDates0()
        for date in dates0{
            let _ = CDDate(date: date, taxPayer: taxPayer!, context: NSManagedObjectContext.MR_defaultContext())
        }
        
        let dates1 = generateDates1()
        let array = CDDateQueries.overlapedDatesArrayWithDatesArray(dates1, taxPayer: taxPayer!)
        
        XCTAssertEqual(0, array.count)
    }
    
    
    func testOverlapingDates(){
        
        let dates0 = generateDates0()
        for date in dates0{
            let _ = CDDate(date: date, taxPayer: taxPayer!, context: NSManagedObjectContext.MR_defaultContext())
        }
        let array = CDDateQueries.overlapedDatesArrayWithDatesArray(dates0, taxPayer: taxPayer!)
        XCTAssertEqual(dates0.count, array.count)
    }
    
    
    
    func testOverlapingDatesWithSameCountry(){
        
        //Crear un Stay con fechas y código de país(a)
        let dates = generateDates0()
        let _ = CDStay(dates: dates, taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let array = CDDateQueries.overlapedDatesArrayWithDatesArray(dates, taxPayer: taxPayer!, countryCode: colombiaCountryCode)
        XCTAssertEqual(dates.count, array.count)
    }
    
    func testOverlapingDatesWithDifferentCountry(){
        
        //Crear un Stay con fechas y código de país(a)
        let dates = generateDates0()
        let _ = CDStay(dates: dates, taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let array = CDDateQueries.overlapedDatesArrayWithDatesArray(dates, taxPayer: taxPayer!, countryCode: usaCountryCode)
        XCTAssertEqual(0, array.count)
    }
    
    
    func testVerifyDateIsInitialDateInStay(){
        let dates = generateDates0()
        let _ = CDStay(dates: dates, taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let initialDate = (NSDate() - 10.days).endOf(.Day)
        
        XCTAssertTrue(CDStayQueries.verifyDateIsInitialDate(initialDate))
    }
    
    func testVerifyDateIsNotInitialDateInStay(){
        let dates = generateDates0()
        let _ = CDStay(dates: dates, taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let initialDate = (NSDate() - 9.days).endOf(.Day)
        
        XCTAssertFalse(CDStayQueries.verifyDateIsInitialDate(initialDate))
    }
    
    func testVerifyDateIsFinalDateInStay(){
        let dates = generateDates0()
        let _ = CDStay(dates: dates, taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let finalDate = NSDate().endOf(.Day)
        
        XCTAssertTrue(CDStayQueries.verifyDateIsFinalDate(finalDate))
    }
    
    func testVerifyDateIsNotFinalDateInStay(){
        let dates = generateDates0()
        let _ = CDStay(dates: dates, taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let finalDate = (NSDate() + 1.days).endOf(.Day)
        
        XCTAssertFalse(CDStayQueries.verifyDateIsFinalDate(finalDate))
    }
    
    func testValidateDates0(){
        
        //Different dates with different countries should be added
        
        let _ = CDStay(dates: generateDates0(), taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let (flag, _) = CDDateQueries.validateDates(generateDates1(), taxPayer: taxPayer!, countryCode: usaCountryCode)
        
        XCTAssertTrue(flag)
    }
    
    func testValidateDates1(){
        //Different dates with the same countries should be added
        
        let _ = CDStay(dates: generateDates0(), taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let (flag, _) = CDDateQueries.validateDates(generateDates1(), taxPayer: taxPayer!, countryCode: colombiaCountryCode)
        
        XCTAssertTrue(flag)
        
    }
    
    func testValidateDates2(){
        //Exact dates with the same countries should not be added
        
        let _ = CDStay(dates: generateDates0(), taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let (flag, _) = CDDateQueries.validateDates(generateDates0(), taxPayer: taxPayer!, countryCode: colombiaCountryCode)
        
        XCTAssertFalse(flag)
    }
    
    func testValidateDates3(){
        //Adjacent dates with different countries should be added. In this case the adjacency is: (dates to be added).finalDate == stay.InitialDate
        
        let _ = CDStay(dates: generateDates0(), taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let (flag, _) = CDDateQueries.validateDates(generateAdjacentDates(), taxPayer: taxPayer!, countryCode: usaCountryCode)
        
        XCTAssertTrue(flag)
    }
    
    func testValidateDates4(){
        //Adjacent dates with different countries should be added. In this case the adjacency is: (dates to be added).initialDate == stay.FinalDate
        
        let _ = CDStay(dates: generateDates0(), taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let (flag, _) = CDDateQueries.validateDates(generateAdjacentDates1(), taxPayer: taxPayer!, countryCode: usaCountryCode)
        
        XCTAssertTrue(flag)
    }
    
    func testValidateDates5(){
        //Adjacent dates with different countries should be added. In this case the adjacency is: (dates to be added).initialDate == stay.FinalDate && (dates to be added).finalDate == anotherStay.FinalDate
        
        
        let _ = CDStay(dates: generateDates0(), taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let (flag, _) = CDDateQueries.validateDates(generateAdjacentDates1(), taxPayer: taxPayer!, countryCode: usaCountryCode)
        
        XCTAssertTrue(flag)
    }
    
    
    func testValidateDates6(){
        /*
         Try to add dates inside a dates stay with different countries. This should not be possible
         Example:
         Colombia: 9-15 Sept 2016
         Usa: 10-12 Sept 2016
         */
        
        
        let _ = CDStay(dates: generateDates0(), taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let (flag, _) = CDDateQueries.validateDates([(NSDate() - 3.days).endOf(.Day), (NSDate() - 2.days).endOf(.Day)], taxPayer: taxPayer!, countryCode: usaCountryCode)
        
        XCTAssertFalse(flag)
    }
    
    func testValidateDates7(){
        /*
         Try to add 2 equal stays with different countries. This should not be possible
         Example:
         Colombia: 9-15 Sept 2016
         Usa: 9-15 Sept 2016
         */
        
        let dates = [(NSDate() - 3.days).endOf(.Day), (NSDate() - 2.days).endOf(.Day)]
        
        let _ = CDStay(dates: dates, taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let (flag, _) = CDDateQueries.validateDates(dates, taxPayer: taxPayer!, countryCode: usaCountryCode)
        
        XCTAssertFalse(flag)
    }
    
    func testValidateDates8(){
        /*
         Try to add 2 equal stays with different countries. This should be possible
         Example:
         Colombia: 9 Sept 2016
         Usa: 9 Sept 2016
         */
        
        let dates = [(NSDate() - 3.days).endOf(.Day)]
        
        let _ = CDStay(dates: dates, taxPayer: taxPayer!, countryCode: colombiaCountryCode, context: NSManagedObjectContext.MR_defaultContext())
        
        let (flag, _) = CDDateQueries.validateDates(dates, taxPayer: taxPayer!, countryCode: usaCountryCode)
        
        XCTAssertTrue(flag)
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
    
    private func generateAdjacentDates() -> Array<NSDate>{
        
        var datesArray = Array<NSDate>()
        for i in 10...13{
            let date = (NSDate() - i.days).endOf(.Day)
            datesArray.append(date)
        }
        
        return datesArray.reverse()
    }
    
    private func generateAdjacentDates1() -> Array<NSDate>{
        
        var datesArray = Array<NSDate>()
        for i in 0...3{
            let date = (NSDate() + i.days).endOf(.Day)
            datesArray.append(date)
        }
        
        return datesArray
    }
    
    private func generateDates1() -> Array<NSDate>{
        var datesArray = Array<NSDate>()
        
        
        for i in 11...20 {
            
            let date = (NSDate() - i.days).endOf(.Day)
            datesArray.append(date)
        }
        return datesArray.reverse()
    }
    
    private func generateDates2() -> Array<NSDate>{
        var datesArray = Array<NSDate>()
        
        
        for i in 15...20 {
            
            let date = (NSDate() - i.days).endOf(.Day)
            datesArray.append(date)
        }
        return datesArray.reverse()
    }
    
    private func generateAdjacentDates2() -> Array<NSDate>{
        
        var datesArray = Array<NSDate>()
        for i in 10...15{
            let date = (NSDate() - i.days).endOf(.Day)
            datesArray.append(date)
        }
        
        return datesArray.reverse()
    }
    
    
}

extension ValidateStayTests{
    
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
