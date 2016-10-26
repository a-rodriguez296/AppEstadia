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
        
        
        DispatchQueue.global(qos: .background).async {[unowned self] () in
            
            // Get the oldestDate added by the user
            let oldestDate =  CDDateQueries.oldestDateWithTaxPayer(self.taxPayer)
            
            //Newest date last day of the year
            let upperBound = CDDateQueries.newestDateWithTaxPayer(self.taxPayer).endOf(component: .year).endOf(component: .day)
            
            //Initialize DateCalculator with oldest date
            let dateCalculator = DatesCalculatorHelper(endDate: oldestDate)
            
            
            
            self.responseArray.value = dateCalculator.consolidatedCalculations(upperBound, staysArray: CDStay.staysOrderedByInitialDateWithTaxPayer(self.taxPayer)).reversed()
            
            DispatchQueue.main.async {[unowned self] () in
                self.shouldReloadTable!()
                self.performingCalculationsEvent.value = false
                
            }
        }
    }
}
