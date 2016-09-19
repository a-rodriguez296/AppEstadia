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
    
    let cstArrivalDate = 0
    let cstDepartureDate = 1
    var currentButton:Int?
    
    var arrivalDate:NSDate?
    var departureDate:NSDate?
    var datesArray:[NSDate]?
    
    
    @IBOutlet weak var btnArrivalDate: UIButton!
    @IBOutlet weak var btnDepartureDate: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnAddStay: UIButton!
    @IBOutlet weak var btnSelectCountry: UIButton!
    
    
    var taxPayer:CDTaxPayer?
    var selectedCountryTuple:(String, String)?
    
    
    
    //Observables
    var arrivalDateObservable = Observable<NSDate?>(nil)
    var departureDateObservable = Observable<NSDate?>(nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSelectCountry.titleLabel?.textAlignment = .Center
        showInitialAlert()
        
        
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
        
        let name = Observable(selectedCountryTuple)
        let name1 = Observable(selectedCountryTuple)
        
        name1.value = ("camilo", "perez")
        
        
        name.observe { (tuple) in
            //print(tuple)
            }.disposeIn(bnd_bag)
        
        name.value = ("hola", "como estas")
        name.value = ("pdero", "asdflasdf")
        

        name1.value = ("oscar", "florez")
        name.value = ("bruno", "asdf")
        
        name.combineLatestWith(name1).map { (a, b) -> Bool in
            print(a)
            print(b)
            return true
        }
        
        
        combineLatest(name, name1).map { (name, name1) -> Bool in
            
            print(name)
            return true
        }
        
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(5 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            name.value = ("Alejandro", "Rodriguez")
            name1.value = ("dasdf", "prerez")
        }
        
        
        
        arrivalDateObservable.value = NSDate()
        departureDateObservable.value = NSDate() + 1.days
        
        
        
        arrivalDateObservable.value = NSDate() + 20.days
        departureDateObservable.value = NSDate() + 21.days
        
        
        
        //        datePicker.bnd_date.observe {[unowned self] (date) in
        //
        //            if let currentBtn = self.currentButton{
        //                if currentBtn == 0{
        //                    self.arrivalDate = date
        //                    self.arrivalDateObservable.value = date
        //                    self.btnArrivalDate.setTitle(DateFormatHelper.stringFromDate(date), forState: .Normal)
        //
        //
        //                    if self.departureDate == nil{
        //                        self.datePicker.minimumDate = date
        //                    }
        //                }
        //                else{
        //                    self.departureDate = date
        //                    self.departureDateObservable.value = date
        //                    self.btnDepartureDate.setTitle(DateFormatHelper.stringFromDate(date), forState: .Normal)
        //                    self.datePicker.maximumDate = date
        //                    if self.arrivalDate == nil{
        //                        self.datePicker.maximumDate = date
        //                    }
        //                }
        //            }
        //
        //            if self.arrivalDate != nil && self.departureDate != nil{
        //                self.datePicker.minimumDate = nil
        //                self.datePicker.maximumDate = nil
        //            }
        //        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let defaults = NSUserDefaults.standardUserDefaults()
        if let countryCode = defaults.objectForKey("countryCode") as! String?, country = defaults.objectForKey("country") as! String?{
            selectedCountryTuple = (country, countryCode)
            btnSelectCountry.titleLabel?.text = country
        }
        
        
        
    }
    
    //MARK: Buttons actions
    
    @IBAction func didSelectDate(sender: UIDatePicker) {
        
        
        if currentButton! == cstArrivalDate{
            btnArrivalDate.setTitle(DateFormatHelper.stringFromDate(sender.date), forState: .Normal)
            arrivalDate = sender.date
        }
        else{
            btnDepartureDate.setTitle(DateFormatHelper.stringFromDate(sender.date), forState: .Normal)
            departureDate = sender.date
        }
        
        
        if arrivalDate != nil && departureDate != nil && (departureDate < arrivalDate){
            //The user cannot enter a departure date smaller than the arrival date
            let alertController = UIAlertController(title: "Attention", message: "You cannot enter a departure date that is earlier than the arrival day", preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alertController.addAction(dismissAction)
            presentViewController(alertController, animated: true, completion: nil)
            
            btnDepartureDate.setTitle(DateFormatHelper.stringFromDate(arrivalDate!), forState: .Normal)
            departureDate = arrivalDate!
            datePicker.date = arrivalDate!
            
        }
        else{
            if arrivalDate <= departureDate && selectedCountryTuple != nil{
                btnAddStay.enabled = true
                
                datePicker.minimumDate = nil
                datePicker.maximumDate = nil
            }
            
        }
    }
    
    @IBAction func didPressSelectDate(sender: UIButton) {
        
        currentButton = sender.tag
        datePicker.hidden = false
        
        
        //This is in case the user does not move the date picker
        if arrivalDate == nil || departureDate == nil{
            if currentButton == cstArrivalDate{
                btnArrivalDate.setTitle(DateFormatHelper.stringFromDate(datePicker.date), forState: .Normal)
                arrivalDate = datePicker.date
            }
            else{
                departureDate = datePicker.date
                btnDepartureDate.setTitle(DateFormatHelper.stringFromDate(datePicker.date), forState: .Normal)
            }
        }
        
        
        //If the user has entered an arrival date, set the date picker minimum date to such date
        if sender == btnDepartureDate {
            if let arrival = arrivalDate {
                datePicker.minimumDate = arrival
            }
        }
        
        //If the user has entered a departure date, set the date picker maximum date to such date
        if sender == btnArrivalDate{
            if let departure = departureDate{
                datePicker.maximumDate = departure
            }
        }
        
        
        //This if is for the case where the user wants to chose the current date as arrival and departure date
        if arrivalDate != nil && departureDate != nil {
            if arrivalDate <= departureDate && selectedCountryTuple != nil{
                btnAddStay.enabled = true
                
                datePicker.minimumDate = nil
                datePicker.maximumDate = nil
            }
        }
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
            while self.arrivalDate <= self.departureDate {
                
                responseArray.append(self.arrivalDate!.endOf(.Day))
                self.arrivalDate = self.arrivalDate! + 1.days
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                
                //Verify if dates exist
                let (_, date) = CDDateQueries.validateDates(responseArray, taxPayer: self.taxPayer!, countryCode: self.selectedCountryTuple!.1)
                
                if let nonAcceptedDate = date{
                    
                    //If the date exists , show an alert controller
                    let alertController = UIAlertController(title: "", message: "You have already added a stay with date \(DateFormatHelper.stringFromDate(nonAcceptedDate)). You cannot add the same date twice", preferredStyle: .Alert)
                    let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                    alertController.addAction(dismissAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else{
                    
                    //Create the stay
                    let _ = CDStay(dates: responseArray,taxPayer: self.taxPayer!,countryCode: self.selectedCountryTuple!.1, context: NSManagedObjectContext.MR_defaultContext())
                    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.Segues.selectCountrySegue{
            let countriesListVC = segue.destinationViewController as! CountriesListViewController
            countriesListVC.delegate = self
        }
    }
}

extension AddDateViewController: CountriesListProtocol{
    
    func didSelectCountry(countryName: String, countryCode: String) {
        selectedCountryTuple = (countryName, countryCode)
        btnSelectCountry.titleLabel?.text = countryName
        
        
        
        //Save country name and country code
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(countryName, forKey: "country")
        defaults.setObject(countryCode, forKey: "countryCode")
        defaults.synchronize()
    }
}