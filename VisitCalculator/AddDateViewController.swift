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
    
    
    var taxPayer:CDTaxPayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        showInitialAlert()
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
            if arrivalDate <= departureDate{
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
            if arrivalDate <= departureDate{
                btnAddStay.enabled = true
                
                datePicker.minimumDate = nil
                datePicker.maximumDate = nil
            }
        }
    }
    
    @IBAction func didTapOnTheScreen(sender: AnyObject) {
        
        datePicker.hidden = true
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
                if let date = CDDate.verifyDates(responseArray,taxPayer: self.taxPayer!){
                    
                    //If the date exists , show an alert controller
                    let alertController = UIAlertController(title: "", message: "You have already added a stay with date \(DateFormatHelper.stringFromDate(date)). You cannot add the same date twice", preferredStyle: .Alert)
                    let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                    alertController.addAction(dismissAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else{
                    
                    //Create the stay and save it
                    let _ = CDStay(dates: responseArray,taxPayer: self.taxPayer!, context: NSManagedObjectContext.MR_defaultContext())
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion(nil)
                    
                    
                    //Dismiss the view controller
                    self.navigationController?.popViewControllerAnimated(true)
                    
                    //Call the delegate method
                    //self.delegate?.didAddDates()
                    
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
}