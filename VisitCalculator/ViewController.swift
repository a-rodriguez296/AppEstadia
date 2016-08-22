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

class ViewController: UIViewController, WWCalendarTimeSelectorProtocol {
    
    var staysArray = Array<Stay>()
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.translucent = false
        edgesForExtendedLayout = .None
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapButton(sender: AnyObject) {
        
        let selector = WWCalendarTimeSelector.instantiate()
        selector.optionCurrentDate = NSDate()
        selector.optionSelectionType = WWCalendarTimeSelectorSelection.Range
        selector.optionButtonTitleDone = "Listo"
        selector.optionButtonFontColorDone =  UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        selector.optionButtonTitleCancel = "Cancelar"
        selector.optionButtonFontColorCancel = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        selector.delegate = self
        

        selector.optionTopPanelFontColor = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        selector.optionTopPanelBackgroundColor  = .whiteColor()
        selector.optionSelectorPanelBackgroundColor = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        
        
        selector.optionCalendarBackgroundColorPastDatesHighlight = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        selector.optionCalendarBackgroundColorTodayHighlight = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        selector.optionCalendarBackgroundColorFutureDatesHighlight = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        
        
        
        presentViewController(selector, animated: true, completion: nil)
    }
    
    @IBAction func didTapCalcular(sender: AnyObject) {
        
        
        
        let actionController = UIAlertController(title: "", message: "Selecciona la forma como deseas hacer el cálculo", preferredStyle: .ActionSheet)
        
        //Esta es la manera arriesgada
        
        
        let regularCalculation = UIAlertAction(title: "Arriesgada", style: .Default){[unowned self] _ in
            
            let beginingDate = NSDate().startOf(.Year)
            let endDate = NSDate().endOf(.Year)
            
            print(DateFormatHelper.mediumDate().stringFromDate(beginingDate))
            print(DateFormatHelper.mediumDate().stringFromDate(endDate))
            
            
            var count = 0
            
            for stay in self.staysArray {
                for stayDay in stay.dates {
                    if stayDay.isBetweenDates(beginingDate, endDate: endDate){
                        count = count + 1
                    }
                }
            }
            
            let remainingDays = 183 - count
            
            let alertController = UIAlertController(title: "", message: "De los 183 días disponibles, te quedan \(remainingDays) para no ser clasificado como residente", preferredStyle: .Alert)
            
            let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alertController.addAction(dismissAction)
            self.presentViewController(alertController, animated: true, completion: nil)

        }

        actionController.addAction(regularCalculation)
        
        
        //Esta es la manera conservadora
        
        let riskyCalculation = UIAlertAction(title: "Conservadora", style: .Default){[unowned self] _ in
            

            let count = DatesCalculatorHelper.countDaysWithinTheLastYearWithArray(self.staysArray)
            let remainingDays = DatesCalculatorHelper.remainingDaysWithCount(count)
            let alertController = UIAlertController(title: "", message: "En los últimos 365 días, Usted ha permanecido \(count). \n Le quedan quedan \(remainingDays) para no volverse residente", preferredStyle: .Alert)
            
            let dismissAction = UIAlertAction(title: "Ok", style: .Cancel, handler: nil)
            alertController.addAction(dismissAction)
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }

        actionController.addAction(riskyCalculation)
        
        let cancel = UIAlertAction(title: "Cancelar", style: .Cancel, handler: nil)
        actionController.addAction(cancel)
        
        presentViewController(actionController, animated: true, completion: nil)
        
    }
    
    
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, dates: [NSDate]) {
        print("Selected Multiple Dates \n\(dates)\n---")
        
        
        let stay = Stay(dates: dates)
        staysArray.append(stay)
        tableView.reloadData()
    }
}

extension ViewController:UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staysArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .Subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = staysArray[indexPath.row].description
        cell.detailTextLabel?.text = "Total días: " + String(staysArray[indexPath.row].dates.count)
        return cell
    }
}

