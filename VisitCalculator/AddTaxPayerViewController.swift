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
    
    
    fileprivate let viewModel = AddTaxPayerViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
    }
    
    
    //MARK: BOND
    func bindViewModel(){
        
        viewModel.firstLastName.bidirectionalBind(to: txtName.bnd_text)
        viewModel.id.bidirectionalBind(to: txtId.bnd_text)
        viewModel.validData.bind(to: btnDone.bnd_isHidden)
        btnDone.bnd_tap.bind(to: viewModel.btnDoneEvent)
        
        
        _ = viewModel.popViewController.observeNext {[unowned self] (flag) in
            if flag{
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
        title = viewModel.title
    }
}
