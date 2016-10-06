//
//  AddTaxPayerViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/22/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import Bond
import MagicalRecord
import TPKeyboardAvoiding

class AddTaxPayerViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var scrollView: TPKeyboardAvoidingScrollView!
    
    
    private let viewModel = AddTaxPayerViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    
    //MARK: BOND
    func bindViewModel(){
       
        viewModel.firstLastName.bidirectionalBindTo(txtName.bnd_text)
        viewModel.id.bidirectionalBindTo(txtId.bnd_text)
        viewModel.validData.bindTo(btnDone.bnd_hidden)
        
        btnDone.bnd_tap.bindTo(viewModel.btnDoneEvent)
        
        
        viewModel.popViewController.observeNew {[unowned self] (flag) in
            if flag{
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
        
        title = viewModel.title
    }
}
