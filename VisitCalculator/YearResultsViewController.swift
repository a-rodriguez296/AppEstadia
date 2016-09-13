//
//  YearResultsViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/1/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import SwiftDate
import MBProgressHUD

class YearResultsViewController: UIViewController {
    
    @IBOutlet weak var lblYearResults: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Year Results"
        
        //If I dont do this, I get a text on the label I don't want
        lblYearResults.text = ""
        
        //Ensure that the user has entered at least one date
        if CDDate.MR_countOfEntities() > 0 {
            
            
            let progressHud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow!, animated: true)
            progressHud.mode = .Indeterminate
            progressHud.label.text = "Performing calculations"
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                // Get the oldestDate added by the user
                let oldestDate =  CDDate.oldestDate()
                
                //Get this year's last day
                let upperBound = NSDate().endOf(.Year).endOf(.Day)
                
                //Initialize DateCalculator with oldest date
                let dateCalculator = DatesCalculatorHelper(endDate: oldestDate)
                
                
                
                let response = dateCalculator.consolidatedCalculations(upperBound, staysArray: CDStay.staysOrderedByInitialDate())
                
                var responseText = ""
                for r in response{
                    responseText += r.description
                }

                dispatch_async(dispatch_get_main_queue()) {
                    
                    MBProgressHUD.hideHUDForView(UIApplication.sharedApplication().keyWindow!, animated: true)
                    
                    self.lblYearResults.text = responseText
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
