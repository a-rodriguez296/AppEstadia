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
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var taxPayer:CDTaxPayer?
    
    
    var responseArray:[YearResponse]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
    }
    
    func setupTable(){
        
        tableView.registerNib(UINib(nibName: Constants.Cells.YearConclusion.yearConclusionCell,  bundle: nil), forCellReuseIdentifier: Constants.Cells.YearConclusion.yearConclusionCell)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 86
        tableView.tableFooterView = UIView()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Year Results"
        
        
        
        //Ensure that the user has entered at least one date
        if CDDate.MR_countOfEntities() > 0 {
            
            
            let progressHud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow!, animated: true)
            progressHud.mode = .Indeterminate
            progressHud.label.text = "Performing calculations"
            
            let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
            dispatch_async(dispatch_get_global_queue(priority, 0)) {
                
                // Get the oldestDate added by the user
                let oldestDate =  CDDateQueries.oldestDateWithTaxPayer(self.taxPayer!)
                
                //Get this year's last day
                let upperBound = NSDate().endOf(.Year).endOf(.Day)
                
                //Initialize DateCalculator with oldest date
                let dateCalculator = DatesCalculatorHelper(endDate: oldestDate)
                
                
                
                self.responseArray = dateCalculator.consolidatedCalculations(upperBound, staysArray: CDStay.staysOrderedByInitialDateWithTaxPayer(self.taxPayer!)).reverse()
                
               
                
                dispatch_async(dispatch_get_main_queue()) {
                     self.tableView.reloadData()
                    MBProgressHUD.hideHUDForView(UIApplication.sharedApplication().keyWindow!, animated: true)
                    
                    //self.lblYearResults.text = responseText
                }
            }
        }
    }
}


extension YearResultsViewController: UITableViewDataSource{
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = responseArray?.count else{
            return 0
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Cells.YearConclusion.yearConclusionCell) as! YearsConclusionCell
        
        cell.initializeWithYearResponse(responseArray![indexPath.row])
        return cell
    }
}
