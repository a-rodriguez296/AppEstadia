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
import MagicalRecord

class InsertDatesController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let stayHandler = StayHandler.sharedInstance
    
    var stays:[CDStay]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        
        title = "Insert Dates"
        
        self.stays = CDStay.MR_findAllSortedBy("initialDate", ascending: true, inContext: NSManagedObjectContext.MR_defaultContext()) as? [CDStay]
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
        let stay = stays![indexPath.row]
        let _  = stay.MR_deleteEntityInContext(NSManagedObjectContext.MR_defaultContext())
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion(nil)
        self.stays = CDStay.MR_findAllSortedBy("initialDate", ascending: true, inContext: NSManagedObjectContext.MR_defaultContext()) as? [CDStay]
        
        //stayHandler.deleteStayWithIndex(indexPath.row)
        
        
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
        return stays.count
        //return stayHandler.staysCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = MGSwipeTableCell.init(style: .Subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = stays[indexPath.row].descriptionString()
        cell.detailTextLabel?.text = "Total days: " + String(stays[indexPath.row].dates!.count)
        
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
        
        //Parte Core Data
        
        //Verify if dates exist
        if let date = CDDate.verifyDates(dates){
            let alertController = UIAlertController(title: "", message: "You have already added a stay with date \(DateFormatHelper.stringFromDate(date)). You cannot add the same date twice", preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alertController.addAction(dismissAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else{
            let _ = CDStay(name: "", dates: dates, context: NSManagedObjectContext.MR_defaultContext())
            tableView.reloadData()
        }
        
        
        
        
        //        let stay = Stay(dates: setDatesToEndOfTheDay(dates))
        //        if let date = stayHandler.addStay(stay){
        //            let alertController = UIAlertController(title: "", message: "You have already added a stay with date \(DateFormatHelper.stringFromDate(date)). You cannot add the same date twice", preferredStyle: .Alert)
        //            let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
        //            alertController.addAction(dismissAction)
        //            self.presentViewController(alertController, animated: true, completion: nil)
        //        }
        //        else{
        //            tableView.reloadData()
        //        }
    }
    
    func WWCalendarTimeSelectorWillDismiss(selector: WWCalendarTimeSelector) {
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreWithCompletion { (success, error) in
            if success{
                self.stays = CDStay.MR_findAllSortedBy("initialDate", ascending: true, inContext: NSManagedObjectContext.MR_defaultContext()) as? [CDStay]
                //CDStay.MR_findAll() as? [CDStay]
                self.tableView.reloadData()
            }
        }
    }
}

