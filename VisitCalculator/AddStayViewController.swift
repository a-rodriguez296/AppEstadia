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
import MBProgressHUD



class AddStayViewController: UIViewController {
    
    var currentButton:Int?
    
    
    var datesArray:[NSDate]?
    
    var timer:NSTimer?
    
    @IBOutlet weak var lblArrivalDate: UILabel!
    @IBOutlet weak var lblDepartureDate: UILabel!
    @IBOutlet weak var btnArrivalDate: UIButton!
    @IBOutlet weak var btnDepartureDate: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnAddStay: UIButton!
    @IBOutlet weak var lblSelectedCountry: UILabel!
    @IBOutlet weak var btnHelp: UIButton!
    //    @IBOutlet weak var datePickerHeightCst: NSLayoutConstraint!
    //    @IBOutlet weak var datePickerHeightIphone4SCst: NSLayoutConstraint!
    
    
    @IBOutlet weak var btnBusiness: UIButton!
    @IBOutlet weak var btnVacations: UIButton!
    
    
    var taxPayer:CDTaxPayer?
    
    var viewModel:AddStayViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let selectedCountryFlag = viewModel!.selectedCountry.map {[unowned self] country -> Bool in
            self.btnAddStay.enabled = !country.countryName.isEmpty
            return !country.countryName.isEmpty}

        selectedCountryFlag.observe {[unowned self] (flag) in
            
            self.btnAddStay.backgroundColor = flag ? UIColor.backgroundYellowColor() : UIColor.disabledGrayColor()
            
        }
        
        //Buttons
        btnBusiness.bnd_tap.bindTo(viewModel!.btnBusinessEvent)
        btnVacations.bnd_tap.bindTo(viewModel!.btnVacationsEvent)
        
        btnArrivalDate.bnd_tap.bindTo(viewModel!.btnArrivalDateEvent)
        btnDepartureDate.bnd_tap.bindTo(viewModel!.btnDepartureDateEvent)
        
        //Labels
        viewModel?.arrivalDate
            .map({
                return DateFormatHelper.stringFromDate($0)
            })
            .observe({[unowned self] (st) in
                self.lblArrivalDate.text = st
                })
        
        viewModel?.departureDate
            .map({
                return DateFormatHelper.stringFromDate($0)
            })
            .observe({[unowned self] (st) in
                self.lblDepartureDate.text = st
                })
        
        //Date picker visibility
        viewModel?.datePickerVisibility
            .observe({[unowned self] (flag) in
                self.datePicker.hidden = flag
                self.btnAddStay.hidden = !flag
                self.btnHelp.hidden = !flag
                
                })
        
        datePicker.bnd_date.bindTo(viewModel!.genericDate)
        
        //Business vacations buttons
        viewModel?.stayType
            .observe({[unowned self] (flag) in
                self.btnBusiness.selected = flag
                self.btnVacations.selected = !flag
                })
        
        //Calendar buttons
        viewModel?.buttonsState
            .observe({[unowned self] (state) in
                switch state{
                case .ArrivalDisabled:
                    self.btnArrivalDate.enabled = false
                case .DepartureDisabled:
                    self.btnDepartureDate.enabled = false
                case .BothEnabled:
                    self.btnArrivalDate.enabled = true
                    self.btnDepartureDate.enabled = true
                }
                })
        
        //Done Button
        btnAddStay.bnd_tap.bindTo(viewModel!.btnAddStayEvent)
        
        //Activity Indicator
        viewModel?.performingCalculationsEvent.observeNew({ (flag) in
            if flag{
                //Mostrarlo
                let progressHud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow!, animated: true)
                progressHud.mode = .Indeterminate
                progressHud.label.text = "Performing Calculations"
            }
            else{
                //Quitarlo
                MBProgressHUD.hideHUDForView(UIApplication.sharedApplication().keyWindow!, animated: true)
            }
        })
        
        btnAddStay.bnd_enabled.bindTo(viewModel!.btnAddStayEnabled)
        
        viewModel?.dismissVC.observeNew({ [unowned self](flag) in
            if flag{
                self.navigationController?.popViewControllerAnimated(true)
            }
            })
        
        
        
        //Country Button
        viewModel?.lblCountryText.bindTo(lblSelectedCountry.bnd_text)
        
        viewModel?.nonAcceptedDateEvent.observeNew({[unowned self] (date) in
            
            self.presentNoNValidStayWithDate(date)
            })
        
        showInitialAlert()
        title = viewModel!.title
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
        viewModel!.dismissDatePicker()
    }
    
    @IBAction func didTapSelectCountry(sender: AnyObject) {
        stopTimer()
        
        let countriesVC = CountriesListViewController()
        countriesVC.delegate = self
        navigationController?.pushViewController(countriesVC, animated: true)
    }
    
    @IBAction func didTapOnHelp(sender: AnyObject) {
        stopTimer()
        presentInitialAlert(nil)
    }
    
    //MARK: Helper Functions
    
    func showInitialAlert(){
        
        if viewModel!.initialAlertFlag{
            
            //Show initial alert
            timer = NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: #selector(presentInitialAlert(_:)), userInfo: nil, repeats: false)
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    func presentInitialAlert(timer:NSTimer?){
        viewModel!.updateAlertFlag()
        SCLAlertView().showInfo("", subTitle: NSLocalizedString("Remember to include the date you arrieved and the date you left the country.", comment: ""), closeButtonTitle: NSLocalizedString("Ok", comment: ""), duration: 9.5, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .LeftToRight)
    }
    
    func presentAlertNonValidDate(){
        //The user cannot enter a departure date smaller than the arrival date
        SCLAlertView().showInfo("", subTitle: NSLocalizedString("You cannot enter a departure date that is earlier than the arrival date", comment: ""), closeButtonTitle: NSLocalizedString("Ok", comment: ""), duration: 4.0, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .LeftToRight)
    }
    
    func presentNoNValidStayWithDate(date: NSDate){
        //If the date exists , show an alert controller
        SCLAlertView().showInfo("", subTitle:String(format:NSLocalizedString("You have already added a stay with date %@. You cannot add the same date twice", comment: ""), DateFormatHelper.stringFromDate(date)) , closeButtonTitle: NSLocalizedString("Ok", comment: ""), duration: 5.0, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .LeftToRight)
    }
}