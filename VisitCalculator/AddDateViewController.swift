//
//  AddDateViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/8/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import SwiftDate

protocol AddDateProtocol {
    func didAddDates(dates: [NSDate])
}

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
    
    
    var delegate:AddDateProtocol?
    
    
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
            if sender.date >= arrivalDate!{
                btnDepartureDate.setTitle(DateFormatHelper.stringFromDate(sender.date), forState: .Normal)
                departureDate = sender.date
            }
            else{
                //The user cannot enter a departure date smaller than the arrival date
                let alertController = UIAlertController(title: "Attention", message: "You cannot enter a departure date that is earlier than the arrival day", preferredStyle: .Alert)
                let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
                alertController.addAction(dismissAction)
                presentViewController(alertController, animated: true, completion: nil)
                
            }
        }
        
        btnAddStay.enabled = arrivalDate <= departureDate
    }
    
    @IBAction func didPressSelectDate(sender: AnyObject) {
        
        currentButton = sender.tag!
        
        datePicker.hidden = false
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
                //Call the delegate method
                self.delegate?.didAddDates(responseArray)
                
                //Dismiss the view controller
               self.navigationController?.popViewControllerAnimated(true)
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