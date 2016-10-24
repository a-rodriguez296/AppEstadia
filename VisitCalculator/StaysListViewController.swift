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
    
    var viewModel:StaysListViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        viewModel!.performFetch()
        viewModel!.fetchedResultsController.delegate = self

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
    
    //MARK: Alert Methods
    func showInitialAlert(){
        
        if viewModel!.showInitialAlertFlag{
            
            //Show initial alert
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.showAlert()
            })
        }
    }
    
    func showAlert(){
        
        SCLAlertView().showInfo("", subTitle: viewModel!.alertMessage, closeButtonTitle:viewModel!.okComment, duration: 9.5, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .LeftToRight)
    }
}