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


//MARK: UITableViewDataSource
extension StaysListViewController:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel!.numberOfRowsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.Dates.datesCell) as! DatesCell
        let stay = viewModel!.objectAtIndexPath(indexPath)
        
        cell.initializeCellWithStay(stay)
        cell.selectionStyle = .none
        
        let deleteButton = MGSwipeButton(title: viewModel!.deleteComment, backgroundColor: UIColor.deleteRedColor(), callback: {[unowned self]
            (sender: MGSwipeTableCell!) -> Bool in
            self.viewModel!.deleteElement(stay)
            return true
            })
        
        
        cell.rightButtons = [deleteButton]
        cell.rightSwipeSettings.transition = MGSwipeTransition.drag
        return cell
    }
}

//MARK: NSFetchedResultsControllerDelegate
extension StaysListViewController: NSFetchedResultsControllerDelegate{
    
    
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
