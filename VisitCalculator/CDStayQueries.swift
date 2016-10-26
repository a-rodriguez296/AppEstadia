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
    
    class func verifyDateIsInitialDate(_ date:Date) -> Bool{
    
        let predicate = NSPredicate(format: "%K = %@", "initialDate", date as CVarArg)
        guard let _ = CDStay.mr_findFirst(with: predicate, sortedBy: "initialDate", ascending: true) else{
            return false
        }
        return true
    }
    
    
    class func verifyDateIsFinalDate(_ date:Date) -> Bool{
        
        let predicate = NSPredicate(format: "%K = %@", "endDate", date as CVarArg)
        guard let _ = CDStay.mr_findFirst(with: predicate, sortedBy: "endDate", ascending: true) else{
            return false
        }
        return true
        
    }
    
}
