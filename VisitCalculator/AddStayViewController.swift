//
//  AddStayViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/8/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import SwiftDate
import MagicalRecord
import Bond
import SCLAlertView



class AddStayViewController: UIViewController {
    
    var currentButton:Int?
    
    
    var datesArray:[NSDate]?
    
    
    @IBOutlet weak var lblArrivalDate: UILabel!
    @IBOutlet weak var lblDepartureDate: UILabel!
    
    @IBOutlet weak var btnArrivalDate: UIButton!
    @IBOutlet weak var btnDepartureDate: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnAddStay: UIButton!
    @IBOutlet weak var btnSelectCountry: UIButton!
    //    @IBOutlet weak var datePickerHeightCst: NSLayoutConstraint!
    //    @IBOutlet weak var datePickerHeightIphone4SCst: NSLayoutConstraint!
    
    //Business = true, vacations = false
    @IBOutlet weak var btnBusiness: UIButton!
    @IBOutlet weak var btnVacations: UIButton!
    
    
    var taxPayer:CDTaxPayer?
    
    
    //Observables
    var arrivalDateObservable = Observable<NSDate?>(NSDate().endOf(.Day))
    var departureDateObservable = Observable<NSDate?>(NSDate().endOf(.Day))
    var selectedCountryObservable = Observable<Country?>(Country())
    var stayTypeObservable = Observable<Bool?>(true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnSelectCountry.titleLabel?.textAlignment = .Center
        showInitialAlert()
        
        title = NSLocalizedString("Add Dates", comment: "")
        
        bondSetup()
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let countryCode = defaults.objectForKey("countryCode") as! String?, countryName = defaults.objectForKey("country") as! String?{
            
            var country = selectedCountryObservable.value
            country?.countryCode = countryCode
            country?.countryName = countryName
            
            selectedCountryObservable.value = country
        }

        let countryName = selectedCountryObservable.value!.countryName
        if !countryName.isEmpty{
            btnSelectCountry.setTitle(countryName, forState: .Normal)
        }
        else{
            btnSelectCountry.setTitle("Select a country", forState: .Normal)
        }
        
        lblArrivalDate.text = DateFormatHelper.stringFromDate(NSDate())
        lblDepartureDate.text = DateFormatHelper.stringFromDate(NSDate())
    }
    
    
    //    override func viewDidLayoutSubviews() {
    //
    //        super.viewDidLayoutSubviews()
    //
    //        let height = UIScreen.mainScreen().bounds.size.height
    //
    //        if height == 480.0{
    //            NSLayoutConstraint.deactivateConstraints([datePickerHeightCst])
    //            NSLayoutConstraint.activateConstraints([datePickerHeightIphone4SCst])
    //        }
    //    }
    
    
    //MARK: IBActions
    @IBAction func didTapOnTheScreen(sender: AnyObject) {
        
        datePicker.hidden = true
        btnDepartureDate.enabled = true
        btnDepartureDate.selected = false
        
        btnArrivalDate.enabled = true
        btnArrivalDate.selected = false
        
        btnAddStay.hidden = false
    }
    
    @IBAction func didTapAddStay(sender: AnyObject) {
        
        var responseArray = Array<NSDate>()
        
        datePicker.hidden = true
        
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
        dispatch_async(dispatch_get_global_queue(priority, 0)) {
            
            //Create the dates array in background
            var arrivalDate = self.arrivalDateObservable.value!
            let departureDate = self.departureDateObservable.value!
            
            while arrivalDate <= departureDate {
                
                responseArray.append(arrivalDate.endOf(.Day))
                arrivalDate = arrivalDate + 1.days
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                
                
                //Verify if dates exist
                let (_, date) = CDDateQueries.validateDates(responseArray, taxPayer: self.taxPayer!, countryCode: self.selectedCountryObservable.value!.countryCode)
                
                if let nonAcceptedDate = date{
                    self.presentNoNValidStayWithDate(nonAcceptedDate)
                }
                else{
                    //Create the stay
                    let _ = CDStay(dates: responseArray,taxPayer: self.taxPayer!,countryCode: self.selectedCountryObservable.value!.countryCode, stayType: self.stayTypeObservable.value!, context: NSManagedObjectContext.MR_defaultContext())
                    
                    //Dismiss the view controller
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
        }
        
        
    }
    @IBAction func didTapSelectCountry(sender: AnyObject) {
        
        let countriesVC = CountriesListViewController()
        countriesVC.delegate = self
        navigationController?.pushViewController(countriesVC, animated: true)
    }
    
    @IBAction func didTapOnHelp(sender: AnyObject) {
        presentInitialAlert()
    }
    
    //MARK: Helper Functions
    
    func showInitialAlert(){
        
        if NSUserDefaults.standardUserDefaults().determineFirstTimeWithKey(Constants.NSUserDefaults.addDatesInitialLaunch){
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(2.5 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                self.presentInitialAlert()
            })
        }
    }
    
    func presentInitialAlert(){
        
        SCLAlertView().showInfo("", subTitle: NSLocalizedString("Remember to include the date you arrieved and the date you left the country.", comment: ""), closeButtonTitle: NSLocalizedString("Ok", comment: ""), duration: 9.5, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .LeftToRight)
    }
    
    func presentAlertNonValidDate(){
        //The user cannot enter a departure date smaller than the arrival date
        SCLAlertView().showInfo("", subTitle: NSLocalizedString("You cannot enter a departure date that is earlier than the arrival date", comment: ""), closeButtonTitle: NSLocalizedString("Ok", comment: ""), duration: 4.0, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .LeftToRight)
    }
    
    func presentNoNValidStayWithDate(date: NSDate){
        //If the date exists , show an alert controller
        SCLAlertView().showInfo("", subTitle: NSLocalizedString("You have already added a stay with date \(DateFormatHelper.stringFromDate(date)). You cannot add the same date twice", comment: ""), closeButtonTitle: NSLocalizedString("Ok", comment: ""), duration: 5.0, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .LeftToRight)
    }
}

