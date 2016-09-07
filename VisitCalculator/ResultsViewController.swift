//
//  ResultsViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/31/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import SwiftDate
import MagicalRecord


class ResultsViewController: UIViewController {

    var selectedDate:NSDate?
    var dateCalculator:DatesCalculatorHelper?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblDateRanges: UILabel!
    @IBOutlet weak var lblRangesTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        lblTitle.text = "Given the date \(DateFormatHelper.stringFromDate(selectedDate!)), these are the results we calculated:"
        dateCalculator = DatesCalculatorHelper(endDate: selectedDate!)
        
        
        let count = dateCalculator!.countDaysWithinTheLastYearWithArray(CDStay.staysOrderedByInitialDate())
        
        if count >= 183{
            lblSubtitle.text = "You have stayed more than one 183 days in the range you specified. Therefore you are considered a resident."
        }
        else{
            lblSubtitle.text = "You have stayed \(count) days in the range you specified. Therefore you have \(182 - count) days remaining this year."
            
            let dateRangesArray = dateCalculator!.dateRangesWithArray(CDStay.staysOrderedByInitialDate())
            
            if dateRangesArray.count > 0{
                lblRangesTitle.text = "The following date ranges won't be counted."
                lblRangesTitle.hidden = false
                
                var responseString = ""
                for range in dateRangesArray{
                    responseString += range.description
                }
                lblDateRanges.text = responseString
                lblDateRanges.hidden = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
