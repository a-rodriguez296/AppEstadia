//
//  DatesCell.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/29/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class DatesCell: MGSwipeTableCell {

    @IBOutlet weak var lblStayTitle: UILabel!
    @IBOutlet weak var lblStayDetail: UILabel!
    @IBOutlet weak var lblStayType: UILabel!
    

    
    func initializeCellWithStay(stay:CDStay){
        
        lblStayTitle.text = stay.descriptionString()
        let locale = NSLocale.currentLocale()
        lblStayDetail.text = String(format: NSLocalizedString("%i days in %@", comment: ""),stay.dates!.count,locale.displayNameForKey(NSLocaleCountryCode, value: stay.countryCode!)!)
        lblStayType.text = stay.type()
    }
    
}
