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

class InsertDatesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnForecasting: UIBarButtonItem!
    @IBOutlet weak var btnSummary: UIBarButtonItem!
    
    var taxPayer:CDTaxPayer?
    
    
    
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Insert Dates"
        
        initializeFetchedResultsController()
        
        
        //Initialize FetchedResultsController
        do {
            try fetchedResultsController?.performFetch()
        }
        catch {
            print("An error occurred")
        }
        
        automaticallyAdjustsScrollViewInsets = false
        
        
        //Show initial alert
        showInitialAlert()
        
        //Sign up notifications
        signUpToNotifications()
        updateToolBarItemsState()
    }
    
    
    //MARK: Segue
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == Constants.Segues.addDateSegue{
            let addDateVC = segue.destinationViewController as! AddDateViewController
            addDateVC.taxPayer = taxPayer
        }
        else if segue.identifier == Constants.Segues.forecastingSegue{
            let chooseCurrentDateVC = segue.destinationViewController as! ChooseCurrentDateController
            chooseCurrentDateVC.taxPayer = taxPayer
        }
        else if segue.identifier == Constants.Segues.yearResultsSegue{
            let yearResultsVC = segue.destinationViewController as! YearResultsViewController
            yearResultsVC.taxPayer = taxPayer
        }
        
        
    }
    
    
    //MARK: Helper functions
    
    func initializeFetchedResultsController(){
        
        let cdStaysFetchRequest = NSFetchRequest(entityName: CDStay.MR_entityName())
        cdStaysFetchRequest.predicate = NSPredicate(format: "%K.%K == %@", "taxPayer", "name",taxPayer!.name!)
        let primarySortDescriptor = NSSortDescriptor(key: "initialDate", ascending: true)
        cdStaysFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: cdStaysFetchRequest,
            managedObjectContext: NSManagedObjectContext.MR_defaultContext(),
            sectionNameKeyPath: nil,
            cacheName: nil)
        fetchedResultsController!.delegate = self
    }
    
    
    func deleteStayWithCell(cell: MGSwipeTableCell){
        
        let indexPath = tableView.indexPathForCell(cell)!
        let stay = fetchedResultsController!.objectAtIndexPath(indexPath)
        stay.MR_deleteEntityInContext(NSManagedObjectContext.MR_defaultContext())
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion(nil)
    }
    
    func showInitialAlert(){
        
        if NSUserDefaults.standardUserDefaults().determineFirstTimeWithKey(Constants.NSUserDefaults.insertDatesVCInitialLaunch){
            
            //Show initial alert
            
            let alertController = UIAlertController(title: "Attention", message: "In order for this app to work properly you must add the dates you stayed in the country for last year and the current year.", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(OKAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}


//MARK: NSNotifications
extension InsertDatesController{
    
    func signUpToNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateToolBarItemsState), name: Constants.NSNotifications.staysChanged, object: nil)
    }
    
    func updateToolBarItemsState(){
        
        //Parte CoreData
        btnForecasting.enabled =  CDStay.staysForTaxPayer(taxPayer!) != 0
        btnSummary.enabled = CDStay.staysForTaxPayer(taxPayer!) != 0
        
    }
}

//MARK: UITableViewDataSource
extension InsertDatesController:UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = fetchedResultsController!.sections else{
            return 0
        }
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MGSwipeTableCell.init(style: .Subtitle, reuseIdentifier: "cell")
        
        let stay = fetchedResultsController!.objectAtIndexPath(indexPath) as! CDStay
        
         let locale = NSLocale.currentLocale()
        
        cell.textLabel?.text = stay.descriptionString()
        cell.detailTextLabel?.text = "Total days: " + String(stay.dates!.count) + " in " + locale.displayNameForKey(NSLocaleCountryCode, value: stay.countryCode!)!
        cell.selectionStyle = .None
        
        let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: UIColor.redColor(), callback: {[unowned self]
            (sender: MGSwipeTableCell!) -> Bool in
            self.deleteStayWithCell(sender)
            return true
            })
        
        
        cell.rightButtons = [deleteButton]
        cell.rightSwipeSettings.transition = MGSwipeTransition.Drag
        return cell
    }
}

//MARK: NSFetchedResultsControllerDelegate
extension InsertDatesController: NSFetchedResultsControllerDelegate{
    
    
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
