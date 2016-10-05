//
//  ViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/10/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import SwiftDate
import MGSwipeTableCell
import MagicalRecord
import SCLAlertView

class StaysListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taxPayer:CDTaxPayer?
    
    
    
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Insert Dates"
        automaticallyAdjustsScrollViewInsets = false
        
        //Setup FetchedResultsController
        setupFetchedResultsController()
        
        //Show initial alert
        showInitialAlert()
        
        setupTableView()
        
    }
    
    //MARK: Actions
    @IBAction func didTapOnHelp(sender: AnyObject) {
        showAlert()
    }
    
    
    //MARK: Helper functions
    func setupTableView(){
        tableView.registerNib(UINib(nibName: Constants.Cells.Dates.datesCell,  bundle: nil), forCellReuseIdentifier: Constants.Cells.Dates.datesCell)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 102
    }
    
    
    func deleteStayWithCell(cell: MGSwipeTableCell){
        
        let indexPath = tableView.indexPathForCell(cell)!
        let stay = fetchedResultsController!.objectAtIndexPath(indexPath)
        stay.MR_deleteEntityInContext(NSManagedObjectContext.MR_defaultContext())
    }
    
    
    //MARK: Alert Methods
    func showInitialAlert(){
        
        if NSUserDefaults.standardUserDefaults().determineFirstTimeWithKey(Constants.NSUserDefaults.insertDatesVCInitialLaunch){
            
            //Show initial alert
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.showAlert()
            })
        }
    }
    
    
    func showAlert(){
        
        SCLAlertView().showInfo("", subTitle: NSLocalizedString("In order for this app to work, you must add the dates you stayed in the country for the last and current year.", comment: ""), closeButtonTitle: NSLocalizedString("Ok", comment: ""), duration: 9.5, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .LeftToRight)
    }
}