//
//  DateFormatHelper.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/10/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation

class DateFormatHelper{
    
    class func mediumDate() -> NSDateFormatter{
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.MediumStyle
        return formatter
    }
}
