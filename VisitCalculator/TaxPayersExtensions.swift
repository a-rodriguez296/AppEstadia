//
//  TaxPayersExtensions.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/23/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import UIKit
import MGSwipeTableCell
import MagicalRecord

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
        cell.detailTextLabel?.text = "ID: " + String(taxPayer.id!)
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
            self.performSegueWithIdentifier(Constants.Segues.datesParentViewSegue, sender: taxPayer)
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
            let searchPredicate = NSPredicate(format: "(%K CONTAINS[cd] %@) OR (%K CONTAINS %@)","name", searchText, "id", searchText)
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
