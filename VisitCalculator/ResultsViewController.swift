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

    
    var viewModel:ResultsViewModel?
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var lblRangesTitle: UILabel!
    @IBOutlet weak var lblDateRanges: UILabel!
    @IBOutlet weak var separator: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        title = "Results"
    }
    
    override func viewWillAppear(animated: Bool) {
        
        lblTitle.text = NSLocalizedString(String(format: "Given the date %@, these are the results we calculated:",DateFormatHelper.stringFromDate(viewModel!.selectedDate)), comment: "")
       
        
        
        //count = number of days the tax payer has stayed in the year of the selected date
        let count = viewModel!.count()
        
        
        lblSubtitle.text = NSLocalizedString(String(format: "You have stayed %i days in the range you specified. Therefore you have %i days remaining this year.", count, viewModel!.remainingDaysWithCount(count)), comment: "")
        
        let dateRangesArray = viewModel!.dateRangesArray()
        
        if dateRangesArray.count > 0{
            
            separator.hidden = false
            lblRangesTitle.text = NSLocalizedString("The following date ranges won't be counted.", comment: "")
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
