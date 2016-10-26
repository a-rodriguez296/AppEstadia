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
    
    
    var datesArray:[Date]?
    
    var timer:Timer?
    
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
            self.btnAddStay.isEnabled = !country.countryName.isEmpty
            return !country.countryName.isEmpty}
        
        selectedCountryFlag.observeNext {[unowned self] (flag) in
            
            self.btnAddStay.backgroundColor = flag ? UIColor.backgroundYellowColor() : UIColor.disabledGrayColor()
            
            }.disposeIn(bnd_bag)
        
        //Buttons
        btnBusiness.bnd_tap.bind(to: viewModel!.btnBusinessEvent)
        btnVacations.bnd_tap.bind(to: viewModel!.btnVacationsEvent)
        
        btnArrivalDate.bnd_tap.bind(to: viewModel!.btnArrivalDateEvent)
        btnDepartureDate.bnd_tap.bind(to: viewModel!.btnDepartureDateEvent)
        
        //Labels
        viewModel?.arrivalDate
            .map({
                return DateFormatHelper.stringFromDate($0)
            })
            .observeNext(with: {[unowned self] (st) in
                self.lblArrivalDate.text = st
                })
            .disposeIn(bnd_bag)
        
        viewModel?.departureDate
            .map({
                return DateFormatHelper.stringFromDate($0)
            })
            .observeNext(with: {[unowned self] (st) in
                self.lblDepartureDate.text = st
                })
            .disposeIn(bnd_bag)
        
        //Date picker visibility
        viewModel?.datePickerVisibility
            .observeNext(with: {[unowned self] (flag) in
                self.datePicker.isHidden = flag
                self.btnAddStay.isHidden = !flag
                self.btnHelp.isHidden = !flag
                
                })
            .disposeIn(bnd_bag)
        
        datePicker.bnd_date.bind(to: viewModel!.genericDate)
        
        //Business vacations buttons
        viewModel?.stayType
            .observeNext(with: {[unowned self] (flag) in
                self.btnBusiness.isSelected = flag
                self.btnVacations.isSelected = !flag
                })
        .disposeIn(bnd_bag)
        
        //Calendar buttons
        viewModel?.buttonsState
            .observeNext(with: {[unowned self] (state) in
                switch state{
                case .arrivalDisabled:
                    self.btnArrivalDate.isEnabled = false
                case .departureDisabled:
                    self.btnDepartureDate.isEnabled = false
                case .bothEnabled:
                    self.btnArrivalDate.isEnabled = true
                    self.btnDepartureDate.isEnabled = true
                }
                })
        .disposeIn(bnd_bag)
        
        //Done Button
        btnAddStay.bnd_tap.bind(to: viewModel!.btnAddStayEvent)
        
        //Activity Indicator
        viewModel?.performingCalculationsEvent.observeNext(with: { (flag) in
            if flag{
                //Mostrarlo
                let progressHud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
                progressHud.mode = .indeterminate
                progressHud.label.text = "Performing Calculations"
            }
            else{
                //Quitarlo
                MBProgressHUD.hide(for: UIApplication.shared.keyWindow!, animated: true)
            }
        }).disposeIn(bnd_bag)
        
        //btnAddStay.bnd_isEnabled.bind(signal: viewModel!.btnAddStayEnabled)
        
        viewModel?.dismissVC.observeNext(with: { [unowned self](flag) in
            if flag{
                _ = self.navigationController?.popViewController(animated: true)
            }
            }).disposeIn(bnd_bag)
        
        
        
        //Country Button
        viewModel?.lblCountryText.bind(to: lblSelectedCountry.bnd_text)
        viewModel?.nonAcceptedDateEvent.observeNext(with: {[unowned self] (date) in
            
            self.presentNoNValidStayWithDate(date)
            })
        .disposeIn(bnd_bag)
        
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
    @IBAction func didTapOnTheScreen(_ sender: AnyObject) {
        viewModel!.dismissDatePicker()
    }
    
    @IBAction func didTapSelectCountry(_ sender: AnyObject) {
        stopTimer()
        
        let countriesVC = CountriesListViewController()
        countriesVC.delegate = self
        navigationController?.pushViewController(countriesVC, animated: true)
    }
    
    @IBAction func didTapOnHelp(_ sender: AnyObject) {
        stopTimer()
        presentInitialAlert(nil)
    }
    
    //MARK: Helper Functions
    
    func showInitialAlert(){
        
        if viewModel!.initialAlertFlag{
            
            //Show initial alert
            timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(presentInitialAlert(_:)), userInfo: nil, repeats: false)
        }
    }
    
    func stopTimer(){
        timer?.invalidate()
        timer = nil
    }
    
    func presentInitialAlert(_ timer:Timer?){
        viewModel!.updateAlertFlag()
        SCLAlertView().showInfo("", subTitle: NSLocalizedString("Remember to include the date you arrieved and the date you left the country.", comment: ""), closeButtonTitle: NSLocalizedString("Ok", comment: ""), duration: 9.5, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .leftToRight)
    }
    
    func presentAlertNonValidDate(){
        //The user cannot enter a departure date smaller than the arrival date
        SCLAlertView().showInfo("", subTitle: NSLocalizedString("You cannot enter a departure date that is earlier than the arrival date", comment: ""), closeButtonTitle: NSLocalizedString("Ok", comment: ""), duration: 4.0, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .leftToRight)
    }
    
    func presentNoNValidStayWithDate(_ date: Date){
        //If the date exists , show an alert controller
        SCLAlertView().showInfo("", subTitle:String(format:NSLocalizedString("You have already added a stay with date %@. You cannot add the same date twice", comment: ""), DateFormatHelper.stringFromDate(date)) , closeButtonTitle: NSLocalizedString("Ok", comment: ""), duration: 5.0, colorStyle:  UInt(Constants.ColorsHex.yellow), colorTextButton: 1, circleIconImage: nil, animationStyle: .leftToRight)
    }
}
