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
    
    let searchController = UISearchController(searchResultsController: nil)
    
    //Fetched Results Controller
    lazy var fetchedResultsController: NSFetchedResultsController = {
        let cdStaysFetchRequest = NSFetchRequest(entityName: CDTaxPayer.MR_entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        cdStaysFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: cdStaysFetchRequest,
            managedObjectContext: NSManagedObjectContext.MR_defaultContext(),
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Style
        extendedLayoutIncludesOpaqueBars = false
        navigationController?.navigationBar.translucent = true
        
        title = NSLocalizedString("Taxpayers", comment: "")
        
        generalSetup()
        
        showInitialAlert()
    }
    
    
    //MARK: IBActions
    @IBAction func didTapOnHelp(sender: AnyObject) {
        showAlert()
    }
    
    func didTapAddTaxpayer(sender: AnyObject) {
        
        let addTaxPayerVC = AddTaxPayerViewController()
        navigationController?.pushViewController(addTaxPayerVC, animated: true)
    }
    
    
    //MARK: Helper Methods
    
    func deleteTaxPayerWithIndexPath(indexPath: NSIndexPath){
        let taxPayer = fetchedResultsController.objectAtIndexPath(indexPath)
        taxPayer.MR_deleteEntityInContext(NSManagedObjectContext.MR_defaultContext())
    }
    
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
        
        if NSUserDefaults.standardUserDefaults().determineFirstTimeWithKey(Constants.NSUserDefaults.addTaxPayersInitialLaunch){
            
            //Show initial alert
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.showAlert()
            })
        }
    }
    
    func showAlert(){
        SCLAlertView().showInfo("", subTitle: NSLocalizedString("Tap on the button +, on the top right, to add taxpayers", comment: ""), closeButtonTitle: NSLocalizedString("Ok", comment: ""), duration: 9.5, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .LeftToRight)
    }
    
    func generalSetup(){
     
        //Initialize FetchedResultsController
        initializeFetchedResultsController()
        
        //Initialize searchController
        initializeSearchController()
        
        //Setup TableView
        setupTableView()
        
        //Bar button
        navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(TaxPayersViewController.didTapAddTaxpayer(_:))), animated: true)
    }
    
}

