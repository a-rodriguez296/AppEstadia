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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return viewModel!.numberOfRowsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Cells.Dates.datesCell) as! DatesCell
        let stay = viewModel!.objectAtIndexPath(indexPath)
        
        cell.initializeCellWithStay(stay)
        cell.selectionStyle = .None
        
        let deleteButton = MGSwipeButton(title: viewModel!.deleteComment, backgroundColor: UIColor.deleteRedColor(), callback: {[unowned self]
            (sender: MGSwipeTableCell!) -> Bool in
            self.viewModel!.deleteElement(stay)
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