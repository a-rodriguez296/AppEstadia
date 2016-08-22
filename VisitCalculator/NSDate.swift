//
//  NSDate.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/10/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation

extension NSDate
{
    func isBetweenDates(beginDate: NSDate, endDate: NSDate) -> Bool
    {
        
        //If the date falls outside of the range then return false. Otherwise return true
        if self.compare(beginDate) == .OrderedAscending
        {
            return false
        }
        
        if self.compare(endDate) == .OrderedDescending
        {
            return false
        }
        
        return true
    }
}
