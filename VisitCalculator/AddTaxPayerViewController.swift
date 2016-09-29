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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        combineLatest(txtName.bnd_text, txtId.bnd_text)
            .map { return !$0!.isEmpty && !$1!.isEmpty }
            .observe { self.btnDone.enabled = $0 }
        
        
        title = NSLocalizedString("Add Taxpayer", comment: "")
        
    }
    
    
    @IBAction func didTapAddTaxPayer(sender: AnyObject) {
        
        
        let trimmedName = txtName.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let trimmedId = txtId.text!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        let _ = CDTaxPayer(name: trimmedName, id: trimmedId, context:NSManagedObjectContext.MR_defaultContext())
        
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    
}
