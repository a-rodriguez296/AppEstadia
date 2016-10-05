//
//  StaysListViewControllerExtensions.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 10/5/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import CoreData
import MGSwipeTableCell

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

//MARK: NSFetchedResultsController
extension StaysListViewController{
    
    func setupFetchedResultsController(){
        initializeFetchedResultsController()
        initialFetch()
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
    
    func initialFetch(){
        do {
            try fetchedResultsController?.performFetch()
        }
        catch {
            print("An error occurred")
        }
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