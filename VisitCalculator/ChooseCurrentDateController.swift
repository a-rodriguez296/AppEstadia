//
//  ChooseCurrentDateController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/31/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import SwiftDate

class ChooseCurrentDateController: UIViewController {
    
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnContinue: UIButton!
    
    var selectedDate = NSDate().endOf(.Day)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        
    }
    
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
        
        //Get the year of the date selected
        let selectedDateEndOfYear = selectedDate.endOf(.Year)
        
        let selectedDateBeginingOfTheYear = selectedDate.startOf(.Year)
        
        
        //Verify if for that year the user is resident
        let dateCalculator = DatesCalculatorHelper(endDate: selectedDateBeginingOfTheYear)
        let yearResponse = dateCalculator.consolidatedCalculations(selectedDateEndOfYear, staysArray: CDStay.staysOrderedByInitialDate()).first!
        
        if !yearResponse.flag{
            //The user is not a resident yet, therefore its usefull to perform calculations
            
            performSegueWithIdentifier(Constants.Segues.showResultsSegue, sender: nil)
        }
        else{
            let alertController = UIAlertController(title: "Attention", message: "For \(selectedDateEndOfYear.year), you are a tax resident, therefore it's useless to perform calculations", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OKAction)
            presentViewController(alertController, animated: true, completion: nil)
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let resultsVC = segue.destinationViewController as! ResultsViewController
        resultsVC.selectedDate = selectedDate
    }
}