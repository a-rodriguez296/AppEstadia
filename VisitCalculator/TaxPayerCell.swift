//
//  TaxPayerCell.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/28/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class TaxPayerCell: MGSwipeTableCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblID: UILabel!
    
    
    
    func initializeWithCDTaxPayer(taxPayer: CDTaxPayer){
        
        lblName.text = taxPayer.name
        lblID.text = taxPayer.id
    }
    
}
