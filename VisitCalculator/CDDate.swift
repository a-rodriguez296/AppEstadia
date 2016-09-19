//
//  CDDate.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/6/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import CoreData


class CDDate: NSManagedObject {
    
    // Insert code here to add functionality to your managed object subclass
    
    convenience init(date: NSDate, taxPayer: CDTaxPayer, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entityForName(CDDate.MR_entityName(), inManagedObjectContext: context)
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.date = date
        self.taxPayer = taxPayer
        
    }
    
}
