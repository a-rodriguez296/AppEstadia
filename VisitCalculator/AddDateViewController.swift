//
//  AddDateViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/8/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import SwiftDate
import MagicalRecord
import Bond

class AddDateViewController: UIViewController {
    
    var currentButton:Int?
    
//    var arrivalDate:NSDate?
//    var departureDate:NSDate?
    var datesArray:[NSDate]?
    
    
    @IBOutlet weak var btnArrivalDate: UIButton!
    @IBOutlet weak var btnDepartureDate: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnAddStay: UIButton!
    @IBOutlet weak var btnSelectCountry: UIButton!
    
    //Business = true, vacations = false
    @IBOutlet weak var btnBusiness: UIButton!
    @IBOutlet weak var btnVacations: UIButton!
    
    
    var taxPayer:CDTaxPayer?
    
    
    //Observables
    var arrivalDateObservable = Observable<NSDate?>(NSDate().endOf(.Day))
    var departureDateObservable = Observable<NSDate?>(NSDate().endOf(.Day))
    var selectedCountryObservable = Observable<Country?>(Country())
    var stayTypeObservable = Observable<Bool?>(true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSelectCountry.titleLabel?.textAlignment = .Center
        showInitialAlert()
        
        
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
        }
        
        btnDepartureDate.bnd_tap.observe {
            self.currentButton = 1
            self.datePicker.hidden = false
            self.btnDepartureDate.selected = true
            self.btnArrivalDate.enabled = false
        }
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let countryCode = defaults.objectForKey("countryCode") as! String?, countryName = defaults.objectForKey("country") as! String?{
            
            var country = selectedCountryObservable.value
            country?.countryCode = countryCode
            country?.countryName = countryName
            
            selectedCountryObservable.value = country
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
        }
        
        datePicker.bnd_date.observe {[unowned self] (date) in
            
            if let currentBtn = self.currentButton{
                if currentBtn == 0{
                    
                    self.arrivalDateObservable.value = date
                    self.btnArrivalDate.setTitle(DateFormatHelper.stringFromDate(date), forState: .Normal)
                }
                else{
                   
                    self.departureDateObservable.value = date
                    self.btnDepartureDate.setTitle(DateFormatHelper.stringFromDate(date), forState: .Normal)
                }
            }
        }
        let countryName = selectedCountryObservable.value!.countryName
        if !countryName.isEmpty{
            btnSelectCountry.setTitle(countryName, forState: .Normal)
        }
        else{
            btnSelectCountry.setTitle("Select a country", forState: .Normal)
        }
        
        btnArrivalDate.setTitle(DateFormatHelper.stringFromDate(NSDate()), forState: .Normal)
        btnDepartureDate.setTitle(DateFormatHelper.stringFromDate(NSDate()), forState: .Normal)
        
    }
    
    @IBAction func didTapOnTheScreen(sender: AnyObject) {
        
        datePicker.hidden = true
        btnDepartureDate.enabled = true
        btnDepartureDate.selected = false
        
        btnArrivalDate.enabled = true
        btnArrivalDate.selected = false
    }
    
    @IBAction func didTapAddStay(sender: AnyObject) {
        
        var responseArray = Array<NSDate>()
        
        datePicker.hidden = true
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            //Create the dates array in background
            var arrivalDate = self.arrivalDateObservable.value!
            let departureDate = self.departureDateObservable.value!
            
            while arrivalDate <= departureDate {
                
                responseArray.append(arrivalDate.endOf(.Day))
                arrivalDate = arrivalDate + 1.days
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                
                //Verify if dates exist
                let (_, date) = CDDateQueries.validateDates(responseArray, taxPayer: self.taxPayer!, countryCode: self.selectedCountryObservable.value!.countryCode)
                
                if let nonAcceptedDate = date{
                    self.presentNoNValidStayWithDate(nonAcceptedDate)
                }
                else{
                    //Create the stay
                    let _ = CDStay(dates: responseArray,taxPayer: self.taxPayer!,countryCode: self.selectedCountryObservable.value!.countryCode, stayType: self.stayTypeObservable.value!, context: NSManagedObjectContext.MR_defaultContext())
                    
                    //Dismiss the view controller
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
    }
    
    //Helper Function
    
    //MARK: Helper Functions
    
    func showInitialAlert(){
        
        if NSUserDefaults.standardUserDefaults().determineFirstTimeWithKey(Constants.NSUserDefaults.addDatesInitialLaunch){
            
            //Show initial alert
            
            let alertController = UIAlertController(title: "Attention", message: "Remember to add the date you arrieved and the date you left the country.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OKAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func presentAlertNonValidDate(){
        //The user cannot enter a departure date smaller than the arrival date
        let alertController = UIAlertController(title: "Attention", message: "You cannot enter a departure date that is earlier than the arrival date", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alertController.addAction(dismissAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func presentNoNValidStayWithDate(date: NSDate){
        //If the date exists , show an alert controller
        let alertController = UIAlertController(title: "", message: "You have already added a stay with date \(DateFormatHelper.stringFromDate(date)). You cannot add the same date twice", preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        alertController.addAction(dismissAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.Segues.selectCountrySegue{
            let countriesListVC = segue.destinationViewController as! CountriesListViewController
            countriesListVC.delegate = self
        }
    }
}

extension AddDateViewController: CountriesListProtocol{
    
    func didSelectCountry(countryName: String, countryCode: String) {
        
        selectedCountryObservable.value = Country(countryName: countryName, countryCode: countryCode)
        btnSelectCountry.titleLabel?.text = countryName
        
        //Save country name and country code
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(countryName, forKey: "country")
        defaults.setObject(countryCode, forKey: "countryCode")
        defaults.synchronize()
    }
}