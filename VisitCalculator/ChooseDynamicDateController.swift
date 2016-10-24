//
//  ChooseDynamicDateController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/31/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import SwiftDate
import MBProgressHUD
import Bond


class ChooseDynamicDateController: UIViewController {
    
    @IBOutlet weak var lblSelectedDate: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var btnContinue: UIButton!
    
    @IBOutlet weak var lblResultSelectedDate: UILabel!
    @IBOutlet weak var lblResult: UILabel!
    @IBOutlet weak var lblPlanOtherDates: UILabel!
    
    var selectedDate = NSDate().endOf(.Day)
    
    var taxPayer:CDTaxPayer?
    
    
    var viewModel:ChooseDynamicDateViewModel?
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        title = viewModel?.title
        lblSelectedDate.text = DateFormatHelper.stringFromDate(selectedDate)
        
        viewModel!.selectedDate.map{DateFormatHelper.stringFromDate($0)}.bindTo(lblSelectedDate.bnd_text)
        viewModel!.datePickerVisibility.bindTo(datePicker.bnd_hidden)
        viewModel!.btnContinueVisibility.bindTo(btnContinue.bnd_hidden)
        
        //lbl selected date
        viewModel!.lblResultSelectedDateVisibility.bindTo(lblResultSelectedDate.bnd_hidden)
        viewModel!.lblResultSelectedDate.bindTo(lblResultSelectedDate.bnd_text)
        
        //lbl result i.e. You are a tax resident
        viewModel!.lblResultVisibility.bindTo(lblResult.bnd_hidden)
        viewModel!.lblResult.bindTo(lblResult.bnd_text)
        
        //lbl plan other dates
        viewModel!.lblPlanOtherDatesVisibility.bindTo(lblPlanOtherDates.bnd_hidden)
        
        viewModel!.selectedDate.bidirectionalBindTo(datePicker.bnd_date)
        
        btnContinue.bnd_tap.bindTo(viewModel!.btnContinueEvent)
        
        viewModel!.shouldShowResultsVC = {[unowned self] _ in
            let resultsVC = ResultsViewController()
            resultsVC.selectedDate = self.viewModel!.selectedDate.value
            resultsVC.taxPayer = self.viewModel!.taxPayer
            self.navigationController?.pushViewController(resultsVC, animated: true)
        }
        
        viewModel!.performingCalculationsEvent.observeNew {[unowned self] (flag) in
            if flag{
                //Mostrarlo
                self.showProgressAlert()
            }
            else{
                //Quitarlo
                self.removeProgressAlert()
            }
        }
        
    }
    
    @IBAction func didTapScreen(sender: AnyObject) {
        
        viewModel?.hideDatePicker()
    }

    
    @IBAction func didTapSelectDate(sender: AnyObject) {
        
        viewModel!.showDatePicker()
    }
    
    func showProgressAlert(){
        let progressHud = MBProgressHUD.showHUDAddedTo(UIApplication.sharedApplication().keyWindow!, animated: true)
        progressHud.mode = .Indeterminate
        progressHud.label.text = NSLocalizedString("Performing Calculations", comment: "")

    }
    
    func removeProgressAlert(){
        MBProgressHUD.hideHUDForView(UIApplication.sharedApplication().keyWindow!, animated: true)
    }
}