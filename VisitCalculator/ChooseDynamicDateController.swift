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
    
    var selectedDate = Date().endOf(component: .day)
    
    var taxPayer:CDTaxPayer?
    
    
    var viewModel:ChooseDynamicDateViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblSelectedDate.text = DateFormatHelper.stringFromDate(selectedDate)
        
        viewModel!.selectedDate.map{DateFormatHelper.stringFromDate($0)}.bind(to: lblSelectedDate.bnd_text)
        
        viewModel!.datePickerVisibility.bind(to:datePicker.bnd_isHidden)
        
        //lbl selected date
        viewModel!.lblResultSelectedDateVisibility.bind(to:lblResultSelectedDate.bnd_isHidden)
        viewModel!.lblResultSelectedDate.bind(to:lblResultSelectedDate.bnd_text)
        
        //lbl result i.e. You are a tax resident
        viewModel!.lblResultVisibility.bind(to:lblResult.bnd_isHidden)
        viewModel!.lblResult.bind(to:lblResult.bnd_text)
        
        //lbl plan other dates
        viewModel!.lblPlanOtherDatesVisibility.bind(to:lblPlanOtherDates.bnd_isHidden)
        
        viewModel!.selectedDate.bidirectionalBind(to: datePicker.bnd_date)
        btnContinue.bnd_tap.bind(to:viewModel!.btnContinueEvent)
        
        viewModel!.shouldShowResultsVC = {[unowned self] _ in
            let resultsVC = ResultsViewController()
            resultsVC.viewModel = ResultsViewModel(date: self.viewModel!.selectedDate.value, payer: self.viewModel!.taxPayer)
            self.navigationController?.pushViewController(resultsVC, animated: true)
        }
        
        viewModel!.performingCalculationsEvent.observeNext {[unowned self] (flag) in
            if flag{
                //Mostrarlo
                self.showProgressAlert()
            }
            else{
                //Quitarlo
                self.removeProgressAlert()
            }
        }.dispose()
        
    }
    
    @IBAction func didTapScreen(_ sender: AnyObject) {
        
        viewModel?.hideDatePicker()
    }
    
    
    @IBAction func didTapSelectDate(_ sender: AnyObject) {
        
        viewModel!.showDatePicker()
    }
    
    func showProgressAlert(){
        let progressHud = MBProgressHUD.showAdded(to: UIApplication.shared.keyWindow!, animated: true)
        progressHud.mode = .indeterminate
        progressHud.label.text = NSLocalizedString("Performing Calculations", comment: "")
        
    }
    
    func removeProgressAlert(){
        MBProgressHUD.hide(for: UIApplication.shared.keyWindow!, animated: true)
    }
}
