//
//  AddStayViewControllerExtensions.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 10/5/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import Bond


//MARK: Bond setup
extension AddStayViewController{
    
    func bondSetup(){
        
        btnBusiness.bnd_tap
            .observe {
                self.btnBusiness.selected =  !self.btnBusiness.selected
                self.btnVacations.selected =  !self.btnVacations.selected
                if self.btnBusiness.selected == true{
                    self.stayTypeObservable.value = true
                }
        }
        
        btnVacations.bnd_tap
            .observe {
                self.btnVacations.selected =  !self.btnVacations.selected
                self.btnBusiness.selected =  !self.btnBusiness.selected
                if self.btnVacations.selected == true{
                    self.stayTypeObservable.value = false
                }
        }
        
        
        
        btnArrivalDate.bnd_tap.observe {
            self.currentButton = 0
            self.datePicker.hidden = false
            self.btnArrivalDate.selected = true
            self.btnDepartureDate.enabled = false
            self.btnAddStay.hidden = true
        }
        
        btnDepartureDate.bnd_tap.observe {
            self.currentButton = 1
            self.datePicker.hidden = false
            self.btnDepartureDate.selected = true
            self.btnArrivalDate.enabled = false
            self.btnAddStay.hidden = true
        }
        
        let combinedDatesSignal = combineLatest(arrivalDateObservable, departureDateObservable)
            .map({[unowned self] (arrivalDate, departureDate) -> Bool in
                if arrivalDate > departureDate{
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentAlertNonValidDate()
                    })
                }
                return arrivalDate <= departureDate
                })
        
        let countrySignal = selectedCountryObservable
            .map { (country) -> Bool in
                return !country!.countryCode.isEmpty
        }
        
        combineLatest(combinedDatesSignal, countrySignal).observe {[unowned self] (datesSignal, countrySignal) in
            self.btnAddStay.enabled = datesSignal && countrySignal
            self.btnAddStay.backgroundColor = datesSignal && countrySignal ? UIColor.backgroundYellowColor() : UIColor.disabledGrayColor()
        }
        
        datePicker.bnd_date.observe {[unowned self] (date) in
            
            if let currentBtn = self.currentButton{
                if currentBtn == 0{
                    
                    self.arrivalDateObservable.value = date
                    self.lblArrivalDate.text = DateFormatHelper.stringFromDate(date)
                }
                else{
                    
                    self.departureDateObservable.value = date
                    self.lblDepartureDate.text = DateFormatHelper.stringFromDate(date)
                }
            }
        }
        
    }
}

//MARK: CountriesListProtocol
extension AddStayViewController: CountriesListProtocol{
    
    func didSelectCountry(countryName: String, countryCode: String) {
        
        selectedCountryObservable.value = Country(countryName: countryName, countryCode: countryCode)
        btnSelectCountry.titleLabel?.text = countryName
        btnSelectCountry.layoutIfNeeded()
        
        //Save country name and country code
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(countryName, forKey: "country")
        defaults.setObject(countryCode, forKey: "countryCode")
        defaults.synchronize()
    }
}
