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
        
        automaticallyAdjustsScrollViewInsets = false
        tableView.tableFooterView = UIView()
        
        //Initialize FetchedResultsController
        initializeFetchedResultsController()
        
        //Initialize searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = nil
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    //MARK: IBActions
    @IBAction func didTapOnHelp(sender: AnyObject) {}

    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.Segues.datesParentViewSegue{
            
            //Send to insertDatesVC a reference of the TaxPayer object
            let insertDatesParentVC = segue.destinationViewController as! InsertDatesParentViewController
            insertDatesParentVC.taxPayer = sender as? CDTaxPayer
            
        }
    }
    
    
    //MARK: Helper Methods
    
    func deleteTaxPayerWithIndexPath(indexPath: NSIndexPath){
        let taxPayer = fetchedResultsController.objectAtIndexPath(indexPath)
        taxPayer.MR_deleteEntityInContext(NSManagedObjectContext.MR_defaultContext())
    }
    
}

