//
//  YearResultsViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/1/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import SwiftDate

class YearResultsViewController: UIViewController {
    
    @IBOutlet weak var lblYearResults: UILabel!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Year Results"
        
        
        //Ensure that the user has entered at least one date
        if StayHandler.sharedInstance.datesCount() > 0 {
            // Get the oldestDate added by the user
            let oldestDate = StayHandler.sharedInstance.oldestDate()
            
            //Get this year's last day
            let upperBound = NSDate().endOf(.Year).endOf(.Day)
            
            //Initialize DateCalculator with oldest date
            let dateCalculator = DatesCalculatorHelper(endDate: oldestDate)
            
            
            
            let response = dateCalculator.consolidatedCalculations(upperBound, staysArray: StayHandler.sharedInstance.staysArray())
            
            var responseText = ""
            for r in response{
                responseText += r.description
            }
            
            lblYearResults.text = responseText
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}