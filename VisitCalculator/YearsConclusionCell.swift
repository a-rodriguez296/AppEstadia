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
        
        selectionStyle = .None
    }
    
    
    func initializeWithYearResponse(response: YearResponse){
        
        yearResponse = response
        
        
        lblYear.text = String(response.year)
        lblConclusion.text = response.description
        
        if let dateText = response.date{
            lblDate.text = DateFormatHelper.yearResponseFormat().stringFromDate(dateText)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let response = yearResponse{
            
            if let _ = response.date{
                NSLayoutConstraint.deactivateConstraints([lblYearCenterCst])
                NSLayoutConstraint.activateConstraints([lblYearTopCst])
            }
            else{
                lblDate.hidden = true
                NSLayoutConstraint.deactivateConstraints([lblYearTopCst])
                NSLayoutConstraint.activateConstraints([lblYearCenterCst])
            }
        }
    }
    
}
