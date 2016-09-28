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

class TaxPayersViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        extendedLayoutIncludesOpaqueBars = false
        tableView.tableFooterView = UIView()
        
        title = NSLocalizedString("Tax payers", comment: "")
        
        //Initialize FetchedResultsController
        initializeFetchedResultsController()
        
        //Initialize searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = nil
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
        //Bar button
        navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(TaxPayersViewController.didTapAddTaxpayer(_:))), animated: true)
    }
    
    
    
    
    //MARK: IBActions
    @IBAction func didTapOnHelp(sender: AnyObject) {}
    
    func didTapAddTaxpayer(sender: AnyObject) {
        
        let addTaxPayerVC = AddTaxPayerViewController()
        navigationController?.pushViewController(addTaxPayerVC, animated: true)
    }
    
    
    //MARK: Helper Methods
    
    func deleteTaxPayerWithIndexPath(indexPath: NSIndexPath){
        let taxPayer = fetchedResultsController.objectAtIndexPath(indexPath)
        taxPayer.MR_deleteEntityInContext(NSManagedObjectContext.MR_defaultContext())
    }
    
}

