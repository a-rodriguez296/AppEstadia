//
//  ChooseDynamicDateViewModel.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 10/20/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Bond

class ChooseDynamicDateViewModel {
    
    let taxPayer:CDTaxPayer
    
    
    var selectedDate = Observable<Date>(Date().endOf(component: .day))
    
    
    //Visual elements
    var datePickerVisibility = Observable<Bool>(true)
    var btnContinueVisibility = Observable<Bool>(false)
    
    var lblResultVisibility = Observable<Bool>(true)
    var lblResult = Observable<String>("")
    
    var lblResultSelectedDateVisibility = Observable<Bool>(true)
    var lblResultSelectedDate = Observable<String>("")
    
    
    var lblPlanOtherDatesVisibility = Observable<Bool>(true)
    var lblPlanOtherDates = Observable<String>("")
    
    
    //BtnContinueEvent
    var btnContinueEvent = Observable<Void>()
    
    var performingCalculationsEvent = Observable<Bool>(false)
    
    /*
     Show resultsVC closure
     If this closure is called, the view controller has to push the resultsVC
     */
    var shouldShowResultsVC: (() -> ())?
    
    
    init(taxPayer: CDTaxPayer){
        self.taxPayer = taxPayer

        
        
        btnContinueEvent.observeNext {[unowned self] () in
            self.performingCalculationsEvent.value = true
            
            DispatchQueue.global(qos: .background).async{
                
                //Get the year of the date selected
                let selectedDateEndOfYear = self.selectedDate.value.endOf(component: .year)
                
                let selectedDateBeginingOfTheYear = self.selectedDate.value.startOf(component: .year)
                
                //Verify if for that year the user is resident
                let dateCalculator = DatesCalculatorHelper(endDate: selectedDateBeginingOfTheYear)
                let yearResponse = dateCalculator.consolidatedCalculations(selectedDateEndOfYear, staysArray: CDStay.staysOrderedByInitialDateWithTaxPayer(self.taxPayer)).first!
                
               DispatchQueue.main.async{
                    self.performingCalculationsEvent.value = false
                    
                    if !yearResponse.flag{
                        
                        //Show results view controller
                        self.shouldShowResultsVC!()
                    }
                    else{
                        self.lblResultVisibility.value = false
                        self.lblResultSelectedDateVisibility.value = false
                        self.lblPlanOtherDatesVisibility.value = false
                        
                        self.lblResultSelectedDate.value = NSLocalizedString(String(format: "In %@", DateFormatHelper.stringFromDate(self.selectedDate.value)), comment: "")
                        self.lblResult.value = NSLocalizedString("YOU ARE A TAX RESIDENT", comment: "")
                    }
                    
                }
            }
        }.dispose()
    }
    
    func hideDatePicker(){
        
        datePickerVisibility.value = true
        btnContinueVisibility.value = false
    }
    
    func showDatePicker(){
        datePickerVisibility.value = false
        btnContinueVisibility.value = true
        
        lblResultVisibility.value = true
        lblResultSelectedDateVisibility.value = true
        lblPlanOtherDatesVisibility.value = true
    }

}
