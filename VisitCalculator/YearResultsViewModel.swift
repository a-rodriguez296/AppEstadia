//
//  YearResultsViewModel.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 10/24/16.
//  Copyright © 2016 ARF. All rights reserved.
//
import Foundation
import Bond

class YearResultsViewModel {
    
    let taxPayer:CDTaxPayer
    
    var performingCalculationsEvent = Observable<Bool>(false)
    
    var responseArray = Observable<[YearResponse]>(Array<YearResponse>())
    
    var shouldReloadTable: (() -> ())?
    
    
    
    init(payer: CDTaxPayer){
        taxPayer = payer
    }
    
    func performCalculations(){
        
        self.performingCalculationsEvent.value = true
        
        let priority = DISPATCH_QUEUE_PRIORITY_HIGH
        dispatch_async(dispatch_get_global_queue(priority, 0)) {[unowned self] () in
            
            // Get the oldestDate added by the user
            let oldestDate =  CDDateQueries.oldestDateWithTaxPayer(self.taxPayer)
            
            //Get this year's last day
            let upperBound = NSDate().endOf(.Year).endOf(.Day)
            
            //Initialize DateCalculator with oldest date
            let dateCalculator = DatesCalculatorHelper(endDate: oldestDate)
            
            
            
            self.responseArray.value = dateCalculator.consolidatedCalculations(upperBound, staysArray: CDStay.staysOrderedByInitialDateWithTaxPayer(self.taxPayer)).reverse()
            
            dispatch_async(dispatch_get_main_queue()) {[unowned self] () in
                self.shouldReloadTable!()
                self.performingCalculationsEvent.value = false
                
            }
        }
    }
}
