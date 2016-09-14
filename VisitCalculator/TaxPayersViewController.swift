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
        
        //Initialize FetchedResultsController
        initializeFetchedResultsController()
        
        //Initialize searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = nil
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = "Tax Payers"
    }
    
    //MARK: IBActions
    
    @IBAction func didTapAddTaxPayer(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "", message: "Taxpayer data", preferredStyle: .Alert)
        
        //Name
        alertController.addTextFieldWithConfigurationHandler { (textfield) in
            textfield.placeholder = "name"
        }
        
        //RUT
        alertController.addTextFieldWithConfigurationHandler { (textfield) in
            textfield.placeholder = "rut"
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .Default) { (action) in
            
            let name = (alertController.textFields![0] as UITextField).text!
            let rut = (alertController.textFields![1] as UITextField).text!
            
            let _ = CDTaxPayer(name: name, rut: rut, context: NSManagedObjectContext.MR_defaultContext())
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion(nil)
        }
        alertController.addAction(saveAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alertController.addAction(cancelAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: Segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == Constants.Segues.insertDatesSegue{
            
            //Send to insertDatesVC a reference of the TaxPayer object
            let insertDatesVC = segue.destinationViewController as! InsertDatesController
            insertDatesVC.taxPayer = sender as? CDTaxPayer
            
        }
    }
    
    
    //MARK: Helper Methods
    
    func deleteTaxPayerWithIndexPath(indexPath: NSIndexPath){
        let taxPayer = fetchedResultsController.objectAtIndexPath(indexPath)
        taxPayer.MR_deleteEntityInContext(NSManagedObjectContext.MR_defaultContext())
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion(nil)
    }
    
}

//MARK: UITableViewDataSource
extension TaxPayersViewController:UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = fetchedResultsController.sections else{
            return 0
        }
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MGSwipeTableCell.init(style: .Subtitle, reuseIdentifier: "cell")
        
        let taxPayer = fetchedResultsController.objectAtIndexPath(indexPath) as! CDTaxPayer
        
        cell.textLabel?.text = taxPayer.name
        cell.detailTextLabel?.text = "RUT: " + String(taxPayer.rut!)
        cell.selectionStyle = .None
        
        
        let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {[unowned self]
            (sender: MGSwipeTableCell!) -> Bool in
            self.deleteTaxPayerWithIndexPath(indexPath)
            return true
            })
        
        
        cell.rightButtons = [deleteButton]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Drag
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension TaxPayersViewController: UITableViewDelegate{
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let taxPayer = fetchedResultsController.objectAtIndexPath(indexPath) as! CDTaxPayer
        
        dispatch_async(dispatch_get_main_queue(),{
            self.performSegueWithIdentifier(Constants.Segues.insertDatesSegue, sender: taxPayer)
        })
        
    }
}


//MARK: NSFetchedResultsControllerDelegate
extension TaxPayersViewController: NSFetchedResultsControllerDelegate{
    
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        tableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch (type) {
        case .Insert:
            if let indexPath = newIndexPath {
                tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            break;
        case .Delete:
            if let indexPath = indexPath {
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            break;
        case .Update:
            break;
        case .Move:
            break;
        }
    }
}

extension TaxPayersViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        NSFetchedResultsController.deleteCacheWithName("Root")
        if !searchText.isEmpty {
            let searchPredicate = NSPredicate(format: "(%K CONTAINS[cd] %@) OR (%K CONTAINS %@)","name", searchText, "rut", searchText)
            fetchedResultsController.fetchRequest.predicate = searchPredicate
            
        }
        else{
            fetchedResultsController.fetchRequest.predicate = nil
        }
        initializeFetchedResultsController()
        tableView.reloadData()
    }
    
    func initializeFetchedResultsController(){
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            print("An error occurred")
        }
        
    }
}
