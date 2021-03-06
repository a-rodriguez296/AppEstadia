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
    
    var timer:NSTimer?
    

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
        stopTimer()
        showAlert(nil)
    }
    
    
    //MARK: Helper functions
    func setupTableView(){
        tableView.registerNib(UINib(nibName: Constants.Cells.Dates.datesCell,  bundle: nil), forCellReuseIdentifier: Constants.Cells.Dates.datesCell)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 102
    }
    
    func showAlert(timer: NSTimer?){
        viewModel!.updateAlertFlag()
        SCLAlertView().showInfo("", subTitle: viewModel!.alertMessage, closeButtonTitle:viewModel!.okComment, duration: 9.5, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .LeftToRight)

    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    //MARK: Alert Methods
    func showInitialAlert(){
        
        if viewModel!.showInitialAlertFlag{
            
            //Show initial alert
            timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(showAlert(_:)), userInfo: nil, repeats: false)
        }
    }
}