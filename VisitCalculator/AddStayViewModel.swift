//
//  AddStayViewModel.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 10/10/16.
//  Copyright © 2016 ARF. All rights reserved.
//
import Bond
import SwiftDate
import MagicalRecord

class AddStayViewModel {
    
    let title = NSLocalizedString("Add Dates", comment: "")
    
    let initialAlertFlag = NSUserDefaults.standardUserDefaults().determineFirstTimeWithKey(Constants.NSUserDefaults.addDatesInitialLaunch)
    
    var arrivalDate = Observable<NSDate>(NSDate().endOf(.Day))
    var departureDate = Observable<NSDate>(NSDate().endOf(.Day))
    var genericDate = Observable<NSDate>(NSDate())
    
    //Business = true, vacations = false
    var stayType = Observable<Bool>(true)
    
    let btnBusinessEvent = Observable<Void>()
    let btnVacationsEvent = Observable<Void>()
    
    let btnArrivalDateEvent = Observable<Void>()
    let btnDepartureDateEvent = Observable<Void>()
    
    var btnArrivalDateState = Observable<Bool>(true)
    var btnDepartureDateState = Observable<Bool>(true)
    
    let btnAddStayEvent = Observable<Void>()
    
    var performingCalculationsEvent = Observable<Bool>(false)
    
    
    //true = arrival is selected, false = departure is selected
    var buttonsState = Observable<CalendarButtonsState>(CalendarButtonsState.BothEnabled)
    
    var datePickerVisibility = Observable<Bool>(true)
    
    //Variable to identify which calendar button was tapped on
    var currentButton:CurrentButton?
    
    var selectedCountry = Observable<Country>(Country())
    var lblCountryText = Observable<String>("")
    
    var nonAcceptedDateEvent = Observable<NSDate>(NSDate())
    var dismissVC = Observable<Bool>(false)
    
    
    var btnAddStayEnabled = Observable<Bool>(true)
    
    init(taxPayer: CDTaxPayer){
        
        btnBusinessEvent.observeNew {[unowned self] () in
            self.stayType.value = true
        }
        
        btnVacationsEvent.observeNew {[unowned self] () in
            self.stayType.value = false
        }
        
        btnArrivalDateEvent.observeNew {[unowned self] () in
            self.currentButton = CurrentButton.Arrival
            self.buttonsState.value = CalendarButtonsState.DepartureDisabled
            self.datePickerVisibility.value = false
            
        }
        
        btnDepartureDateEvent.observeNew {[unowned self] () in
            self.currentButton = CurrentButton.Departure
            self.buttonsState.value = CalendarButtonsState.ArrivalDisabled
            self.datePickerVisibility.value = false
        }
        
        
        genericDate.observeNew {[unowned self] (date) in
            
            /*
             This conditional is used for the first time the view is loaded.
             When the view is loaded this method is triggered by the date picker, but the current button is not yet initialized
             */
            if let currentButton = self.currentButton{
                
                let helperDate = date.endOf(.Day)
                
                switch currentButton{
                case .Arrival:
                    
                    self.arrivalDate.value = helperDate
                    
                    if helperDate > self.departureDate.value{
                        self.departureDate.value = helperDate
                    }
                    
                case .Departure:
                    self.departureDate.value = helperDate
                    
                    if helperDate < self.arrivalDate.value{
                        self.arrivalDate.value = helperDate
                    }
                }
            }
        }
        
        
        //Country Label
        let defaults = NSUserDefaults.standardUserDefaults()
        if let countryCode = defaults.objectForKey(Constants.NSUserDefaults.countryCode) as! String?, countryName = defaults.objectForKey(Constants.NSUserDefaults.countryName) as! String?{
            
            //Asign to variable, what's saved on user defaults
            var helperCountry = Country()
            helperCountry.countryCode = countryCode
            helperCountry.countryName = countryName
            selectedCountry.value  = helperCountry
            lblCountryText.value = countryName
        }
        else{
            lblCountryText.value = NSLocalizedString("Select a country", comment: "")
        }
        
        selectedCountry.observeNew {[unowned self] (country) in
            
            //Update label
            self.lblCountryText.value = country.countryName
            
            //Save NSuserDefaults
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(country.countryName, forKey: Constants.NSUserDefaults.countryName)
            defaults.setObject(country.countryCode, forKey: Constants.NSUserDefaults.countryCode)
            defaults.synchronize()
        }
        
        
        btnAddStayEvent.observeNew {[unowned self] () in
            
            
            var responseArray = Array<NSDate>()
            
            self.performingCalculationsEvent.value = true
            
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                //Create the dates array in background
                var arrivalDate = self.arrivalDate.value
                let departureDate = self.departureDate.value
                
                while arrivalDate <= departureDate {
                    
                    responseArray.append(arrivalDate.endOf(.Day))
                    arrivalDate = arrivalDate + 1.days
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    
                    self.performingCalculationsEvent.value = false
                    
                    //Verify if dates exist
                    let (_, date) = CDDateQueries.validateDates(responseArray, taxPayer: taxPayer, countryCode: self.selectedCountry.value.countryCode)
                    
                    if let nonAcceptedDate = date{
                       self.nonAcceptedDateEvent.value = nonAcceptedDate
                    }
                    else{
                        //Create the stay
                        let _ = CDStay(dates: responseArray,taxPayer: taxPayer,countryCode: self.selectedCountry.value.countryCode, stayType: self.stayType.value, context: NSManagedObjectContext.MR_defaultContext())
                        
                        //Dismiss the view controller
                        self.dismissVC.value = true
                    }
                }
            }
        }
    }
    
    
    func dismissDatePicker(){
        datePickerVisibility.value = true
        self.buttonsState.value = CalendarButtonsState.BothEnabled
    }
    
    func updateAlertFlag(){
        NSUserDefaults.standardUserDefaults().updateValueWithKey(Constants.NSUserDefaults.addDatesInitialLaunch, value: true)
    }
}

enum CalendarButtonsState:Int {
    case ArrivalDisabled
    case DepartureDisabled
    case BothEnabled
}

enum CurrentButton {
    case Arrival
    case Departure
}
