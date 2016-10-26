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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.TaxPayer.taxPayerCell) as! TaxPayerCell
        
        let taxPayer = viewModel.objectAtIndexPath(indexPath)
        
        cell.initializeWithCDTaxPayer(taxPayer)
        cell.selectionStyle = .none
        
        let deleteButton = MGSwipeButton(title: "Delete", backgroundColor: UIColor.deleteRedColor(), callback: {[unowned self]
            (sender: MGSwipeTableCell!) -> Bool in
            self.viewModel.deleteElement(taxPayer)
            return true
            })
        
        
        cell.rightButtons = [deleteButton]
        cell.rightSwipeSettings.transition = MGSwipeTransition.drag
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension TaxPayersViewController: UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
            break;
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            break;
        case .update:
            break;
        case .move:
            break;
        }
    }
}

//MARK: UISearchResultsUpdating
extension TaxPayersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        viewModel.updateFetchedResultsPredicateWithText(searchText)
        tableView.reloadData()
    }
}
