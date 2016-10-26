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
    
    let initialAlertFlag = UserDefaults.standard.determineFirstTimeWithKey(Constants.NSUserDefaults.addDatesInitialLaunch)
    
    var arrivalDate = Observable<Date>(Date().endOf(component:.day))
    var departureDate = Observable<Date>(Date().endOf(component:.day))
    var genericDate = Observable<Date>(Date())
    
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
    var buttonsState = Observable<CalendarButtonsState>(CalendarButtonsState.bothEnabled)
    
    var datePickerVisibility = Observable<Bool>(true)
    
    //Variable to identify which calendar button was tapped on
    var currentButton:CurrentButton?
    
    var selectedCountry = Observable<Country>(Country())
    var lblCountryText = Observable<String>("")
    
    var nonAcceptedDateEvent = Observable<Date>(Date())
    var dismissVC = Observable<Bool>(false)
    
    
    var btnAddStayEnabled = Observable<Bool>(true)
    
    init(taxPayer: CDTaxPayer){
        

        btnBusinessEvent.observeNext {[unowned self] () in
            self.stayType.value = true
        }.dispose()
        
        btnVacationsEvent.observeNext {[unowned self] () in
            self.stayType.value = false
        }.dispose()
        
        btnArrivalDateEvent.observeNext {[unowned self] () in
            self.currentButton = CurrentButton.arrival
            self.buttonsState.value = CalendarButtonsState.departureDisabled
            self.datePickerVisibility.value = false
            
        }.dispose()
        
        btnDepartureDateEvent.observeNext {[unowned self] () in
            self.currentButton = CurrentButton.departure
            self.buttonsState.value = CalendarButtonsState.arrivalDisabled
            self.datePickerVisibility.value = false
        }.dispose()
        
        
        genericDate.observeNext {[unowned self] (date) in
            
            /*
             This conditional is used for the first time the view is loaded.
             When the view is loaded this method is triggered by the date picker, but the current button is not yet initialized
             */
            if let currentButton = self.currentButton{
                
                let helperDate = date.endOf(component:.day)
                
                switch currentButton{
                case .arrival:
                    
                    self.arrivalDate.value = helperDate
                    
                    if helperDate > self.departureDate.value{
                        self.departureDate.value = helperDate
                    }
                    
                case .departure:
                    self.departureDate.value = helperDate
                    
                    if helperDate < self.arrivalDate.value{
                        self.arrivalDate.value = helperDate
                    }
                }
            }
        }.dispose()
        
        
        //Country Label
        let defaults = UserDefaults.standard
        if let countryCode = defaults.object(forKey: Constants.NSUserDefaults.countryCode) as! String?, let countryName = defaults.object(forKey: Constants.NSUserDefaults.countryName) as! String?{
            
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
        
        selectedCountry.observeNext {[unowned self] (country) in
            
            //Update label
            self.lblCountryText.value = country.countryName
            
            //Save NSuserDefaults
            let defaults = UserDefaults.standard
            defaults.set(country.countryName, forKey: Constants.NSUserDefaults.countryName)
            defaults.set(country.countryCode, forKey: Constants.NSUserDefaults.countryCode)
            defaults.synchronize()
        }.dispose()
        
        
        btnAddStayEvent.observeNext {[unowned self] () in
            
            
            var responseArray = Array<Date>()
            
            self.performingCalculationsEvent.value = true
            
            
            DispatchQueue.global(qos: .background).async {
                
                //Create the dates array in background
                var arrivalDate = self.arrivalDate.value
                let departureDate = self.departureDate.value
                
                while arrivalDate <= departureDate {
                    
                    responseArray.append(arrivalDate.endOf(component:.day))
                    arrivalDate = arrivalDate + 1.days
                }
                
                DispatchQueue.main.async{
                    
                    
                    self.performingCalculationsEvent.value = false
                    
                    //Verify if dates exist
                    let (_, date) = CDDateQueries.validateDates(responseArray as Array<Date>, taxPayer: taxPayer, countryCode: self.selectedCountry.value.countryCode)
                    
                    if let nonAcceptedDate = date{
                       self.nonAcceptedDateEvent.value = nonAcceptedDate
                    }
                    else{
                        //Create the stay
                        let _ = CDStay(dates: responseArray,taxPayer: taxPayer,countryCode: self.selectedCountry.value.countryCode, stayType: self.stayType.value, context: NSManagedObjectContext.mr_default())
                        
                        //Dismiss the view controller
                        self.dismissVC.value = true
                    }
                }
            }
        }.dispose()
    }
    
    
    func dismissDatePicker(){
        datePickerVisibility.value = true
        self.buttonsState.value = CalendarButtonsState.bothEnabled
    }
    
    func updateAlertFlag(){
        UserDefaults.standard.updateValueWithKey(Constants.NSUserDefaults.addDatesInitialLaunch, value: true)
    }
}

enum CalendarButtonsState:Int {
    case arrivalDisabled
    case departureDisabled
    case bothEnabled
}

enum CurrentButton {
    case arrival
    case departure
}
