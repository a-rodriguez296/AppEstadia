//
//  ChooseCurrentDateController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/31/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import WWCalendarTimeSelector
import SwiftDate

class ChooseCurrentDateController: UIViewController {

    @IBOutlet weak var lblSelectedDate: UILabel!
    
    
    var selectedDate:NSDate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Dynamic Date"
    }


    

    @IBAction func didTapSelectDate(sender: AnyObject) {
        
        let selector = WWCalendarTimeSelector.instantiate()
        selector.addStyleToCalendar()
        //selector.option
        selector.delegate = self
        selector.optionShowTopContainer = false
        
        tabBarController?.presentViewController(selector, animated: true, completion: nil)        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let resultsVC = segue.destinationViewController as! ResultsViewController
        if let userSelectedDate = selectedDate{
            resultsVC.selectedDate = userSelectedDate
        }
        else{
            resultsVC.selectedDate = NSDate().endOf(.Day)
        }
    }
    
    
}


extension ChooseCurrentDateController: WWCalendarTimeSelectorProtocol{
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate){
        
        //Update Label
        lblSelectedDate.text = DateFormatHelper.stringFromDate(date.endOf(.Day))
        lblSelectedDate.hidden = false
        
        selectedDate = date.endOf(.Day)
        
    }
    
}