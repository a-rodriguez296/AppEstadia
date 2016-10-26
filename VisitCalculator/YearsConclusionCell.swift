//
//  YearsConclusionCell.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/30/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit

class YearsConclusionCell: UITableViewCell {

    @IBOutlet weak var lblYear: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblConclusion: UILabel!
    
    @IBOutlet weak var lblYearTopCst: NSLayoutConstraint!
    @IBOutlet weak var lblYearCenterCst: NSLayoutConstraint!
    
    var yearResponse:YearResponse?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    
    func initializeWithYearResponse(_ response: YearResponse){
        
        yearResponse = response
        
        
        lblYear.text = String(response.year)
        lblConclusion.text = response.description
        
        if let dateText = response.date{
            lblDate.text = DateFormatHelper.yearResponseFormat().string(from: dateText)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let response = yearResponse{
            
            if let _ = response.date{
                NSLayoutConstraint.deactivate([lblYearCenterCst])
                NSLayoutConstraint.activate([lblYearTopCst])
            }
            else{
                lblDate.isHidden = true
                NSLayoutConstraint.deactivate([lblYearTopCst])
                NSLayoutConstraint.activate([lblYearCenterCst])
            }
        }
    }
    
}
