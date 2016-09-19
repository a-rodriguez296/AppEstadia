//
//  CDStayQueries.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/16/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import MagicalRecord

class CDStayQueries {
    
    class func verifyDateIsInitialDate(date:NSDate) -> Bool{
    
        let predicate = NSPredicate(format: "%K = %@", "initialDate", date)
        guard let _ = CDStay.MR_findFirstWithPredicate(predicate, sortedBy: "initialDate", ascending: true) else{
            return false
        }
        return true
    }
    
    
    class func verifyDateIsFinalDate(date:NSDate) -> Bool{
        
        let predicate = NSPredicate(format: "%K = %@", "endDate", date)
        guard let _ = CDStay.MR_findFirstWithPredicate(predicate, sortedBy: "endDate", ascending: true) else{
            return false
        }
        return true
        
    }
    
}
