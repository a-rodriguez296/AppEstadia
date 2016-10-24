//
//  ResultsViewModel.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 10/24/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Bond

class ResultsViewModel {
    
    
    let selectedDate:NSDate
    let taxPayer:CDTaxPayer
    
    let datesCalculator:DatesCalculatorHelper
    
    
    init(date:NSDate, payer: CDTaxPayer){
        selectedDate = date
        taxPayer = payer
        datesCalculator = DatesCalculatorHelper(endDate: selectedDate)
    }
    
    //Get the number of days the tax payer has stayed in the year of the selected date
    func count() -> Int{
        return datesCalculator.countDaysWithinTheLastYearWithArray(CDStay.staysOrderedByInitialDateWithTaxPayer(taxPayer))
    }
    
    func remainingDaysWithCount(count: Int) -> Int{
        return 182 - count
    }
    
    func dateRangesArray() -> Array<DatesRange>{
        return  datesCalculator.dateRangesWithArray(CDStay.staysOrderedByInitialDateWithTaxPayer(taxPayer))
    }
}
