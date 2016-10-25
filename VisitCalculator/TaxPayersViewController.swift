//
//  TaxPayersViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/13/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import MagicalRecord
import MGSwipeTableCell
import SCLAlertView

class TaxPayersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnHelp: UIButton!
    
    let searchController = UISearchController(searchResultsController: nil)
    let viewModel = TaxPayersViewModel()
    
    var timer:NSTimer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.navigationBar.translucent = true
        
        //Bar button configuration
        navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(TaxPayersViewController.didTapAddTaxpayer(_:))), animated: true)
        
        
        //Initialize Search Controller
        initializeSearchController()
        
        //Setup TableView
        setupTableView()
        
        showInitialAlert()
        
        //MVVM
        title = viewModel.title
        
        btnHelp.bnd_tap
            .observe { [unowned self] _ in
                self.showAlert()
            }
            .disposeIn(bnd_bag)
        
        viewModel.fetchedResultsController.delegate = self
        
    }
    
    
    //MARK: IBActions
    
    
    func didTapAddTaxpayer(sender: AnyObject) {
        
        //Stop timer
        stopTimer()
        
        let addTaxPayerVC = AddTaxPayerViewController()
        navigationController?.pushViewController(addTaxPayerVC, animated: true)
    }
    
    
    //MARK: Helper Methods
    
    func initializeSearchController(){
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = nil
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.barTintColor = .whiteColor()
    }
    
    func setupTableView(){
        tableView.tableFooterView = UIView()
        tableView.registerNib(UINib(nibName: "TaxPayerCell",  bundle: nil), forCellReuseIdentifier: Constants.Cells.TaxPayer.taxPayerCell)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 73
    }
    
    func showInitialAlert(){
        
        if viewModel.showInitialAlertFlag{
            
            //Show initial alert
            timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(timerTrigger(_:)), userInfo: nil, repeats: false)
        }
    }
    
    func timerTrigger(timer: NSTimer){
        viewModel.updateAlertFlag()
        showAlert()
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    func showAlert(){
        SCLAlertView().showInfo("", subTitle: viewModel.alertMessage,
                                closeButtonTitle: NSLocalizedString("Ok", comment: ""),
                                duration: 9.5, colorStyle:  UInt(Constants.ColorsHex.yellow),
                                colorTextButton: 1,
                                circleIconImage: nil,
                                animationStyle: .LeftToRight)
    }
}

