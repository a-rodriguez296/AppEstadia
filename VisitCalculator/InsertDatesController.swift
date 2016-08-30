//
//  ViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/10/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import WWCalendarTimeSelector
import SwiftDate
import MGSwipeTableCell

class InsertDatesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let stayHandler = StayHandler.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        
        title = "Insert Dates"
    }
    
    @IBAction func didTapButton(sender: AnyObject) {
        
        let selector = WWCalendarTimeSelector.instantiate()
        selector.optionSelectionType = WWCalendarTimeSelectorSelection.Range
        selector.addStyleToCalendar()
        selector.delegate = self
        
        tabBarController?.presentViewController(selector, animated: true, completion: nil)
    }
    
    func deleteStayWithCell(cell: MGSwipeTableCell){
        
        let indexPath = tableView.indexPathForCell(cell)!
        
        stayHandler.deleteStayWithIndex(indexPath.row)
        
        
        tableView.beginUpdates()
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        tableView.endUpdates()
    }
    
    
    //MARK: Helper functions
    
    
    func setDatesToEndOfTheDay(dates: [NSDate]) -> [NSDate]{
        //TODO: This should be done inside the library
        
        var datesArray = Array<NSDate>()
        for date in dates{
            let newDate = date.endOf(.Day)
            datesArray.append(newDate)
        }
        return datesArray
    }
    
    
}

//MARK: UITableViewDataSource
extension InsertDatesController:UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stayHandler.staysCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MGSwipeTableCell.init(style: .Subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = stayHandler.stayAtIndex(indexPath.row).description
        cell.detailTextLabel?.text = "Total days: " + String(stayHandler.stayAtIndex(indexPath.row).dates.count)
        
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

//MARK: WWCalendarTimeSelectorProtocol
extension InsertDatesController:WWCalendarTimeSelectorProtocol{
    
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, dates: [NSDate]) {
        selector.dismissViewControllerAnimated(true, completion: nil)
        let stay = Stay(dates: setDatesToEndOfTheDay(dates))
        if let date = stayHandler.addStay(stay){
            let alertController = UIAlertController(title: "", message: "You have already added a stay with date \(DateFormatHelper.stringFromDate(date)). You cannot add the same date twice", preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alertController.addAction(dismissAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            tableView.reloadData()
        }
    }
}

