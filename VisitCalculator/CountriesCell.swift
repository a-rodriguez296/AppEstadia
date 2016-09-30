//
//  CountriesCell.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/30/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit

class CountriesCell: UITableViewCell {

    @IBOutlet weak var lblCountryName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .None
    }
    
    func initializeWithCountryName(name: String){
        
        lblCountryName.text = name
        
    }
    
    
}
