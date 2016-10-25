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
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Cells.TaxPayer.taxPayerCell) as! TaxPayerCell
        
        let taxPayer = viewModel.objectAtIndexPath(indexPath)
        
        cell.initializeWithCDTaxPayer(taxPayer)
        cell.selectionStyle = .None
        
        let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: UIColor.deleteRedColor(), callback: {[unowned self]
            (sender: MGSwipeTableCell!) -> Bool in
            self.viewModel.deleteElement(taxPayer)
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
        
        //Stop timer
        stopTimer()
        
        let taxPayer = viewModel.objectAtIndexPath(indexPath)
        
        let containerVC = ContainerViewController()
        containerVC.taxPayer = taxPayer
        navigationController?.pushViewController(containerVC, animated: true)
        
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

//MARK: UISearchResultsUpdating
extension TaxPayersViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        viewModel.updateFetchedResultsPredicateWithText(searchText)
        tableView.reloadData()
    }
}
