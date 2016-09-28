//
//  ChooseDynamicDateController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/31/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import SwiftDate
import MBProgressHUD

class ChooseDynamicDateController: UIViewController {
    
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnContinue: UIButton!
    
    var selectedDate = NSDate().endOf(.Day)
    
    var taxPayer:CDTaxPayer?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Dynamic Date"
        datePicker.date = selectedDate
        lblSelectedDate.text = DateFormatHelper.stringFromDate(selectedDate)
    }
    
    @IBAction func didTapScreen(sender: AnyObject) {
        
        datePicker.hidden = true
    }
    
    @IBAction func didChangeDate(sender: UIDatePicker) {
        
        selectedDate = sender.date.endOf(.Day)
        lblSelectedDate.text = DateFormatHelper.stringFromDate(sender.date)
    }
    
    
    @IBAction func didTapSelectDate(sender: AnyObject) {
        
        datePicker.hidden = false
    }
    
    @IBAction func didTapContinue(sender: AnyObject) {
        
        
        let progressHud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow!, animated: true)
        progressHud.mode = .Indeterminate
        progressHud.label.text = "Performing Calculations"
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            
            //Get the year of the date selected
            let selectedDateEndOfYear = self.selectedDate.endOf(.Year)
            
            let selectedDateBeginingOfTheYear = self.selectedDate.startOf(.Year)
            
            //Verify if for that year the user is resident
            let dateCalculator = DatesCalculatorHelper(endDate: selectedDateBeginingOfTheYear)
            let yearResponse = dateCalculator.consolidatedCalculations(selectedDateEndOfYear, staysArray: CDStay.staysOrderedByInitialDateWithTaxPayer(self.taxPayer!)).first!
            
            dispatch_async(dispatch_get_main_queue()) {
                MBProgressHUD.hideHUDForView(UIApplication.sharedApplication().keyWindow!, animated: true)
                
                if !yearResponse.flag{
                    //The user is not a resident yet, therefore its usefull to perform calculations
                    
                    let resultsVC = ResultsViewController()
                    resultsVC.selectedDate = self.selectedDate
                    resultsVC.taxPayer = self.taxPayer
                    self.navigationController?.pushViewController(resultsVC, animated: true)
                    
                    
                }
                else{
                    let alertController = UIAlertController(title: "Attention", message: "For \(selectedDateEndOfYear.year), you are a tax resident.", preferredStyle: .Alert)
                    
                    let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alertController.addAction(OKAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }

}