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
        
        setupTableView()
        
    }
    
    
    //MARK: Helper functions
    func setupTableView(){
        tableView.registerNib(UINib(nibName: Constants.Cells.Dates.datesCell,  bundle: nil), forCellReuseIdentifier: Constants.Cells.Dates.datesCell)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 102
    }
    
    
    func initializeFetchedResultsController(){
        
        let cdStaysFetchRequest = NSFetchRequest(entityName: CDStay.MR_entityName())
        cdStaysFetchRequest.predicate = NSPredicate(format: "%K.%K == %@", "taxPayer", "name",taxPayer!.name!)
        let primarySortDescriptor = NSSortDescriptor(key: "initialDate", ascending: false)
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
    }
    
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
    
    
    @IBAction func didTapOnHelp(sender: AnyObject) {
        showAlert()
    }
    
    
}

//MARK: UITableViewDataSource
extension StaysListViewController:UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let sections = fetchedResultsController!.sections else{
            return 0
        }
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Cells.Dates.datesCell) as! DatesCell
        let stay = fetchedResultsController!.objectAtIndexPath(indexPath) as! CDStay
        
        cell.initializeCellWithStay(stay)
        cell.selectionStyle = .None
        
        let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: UIColor.deleteRedColor(), callback: {[unowned self]
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
extension StaysListViewController: NSFetchedResultsControllerDelegate{
    
    
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
