//
//  AddDateViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/8/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import SwiftDate

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
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
        
        while arrivalDate <= departureDate {
            
            responseArray.append(arrivalDate!.endOf(.Day))
            print(DateFormatHelper.stringFromDate(arrivalDate!))
            arrivalDate = arrivalDate! + 1.days
        }
        
        print(responseArray)
    }
    
    
    
}


