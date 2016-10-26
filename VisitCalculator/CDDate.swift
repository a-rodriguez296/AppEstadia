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
    
    convenience init(date: Date, taxPayer: CDTaxPayer, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entity(forEntityName: CDDate.mr_entityName(), in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.date = date
        self.taxPayer = taxPayer
        
    }
    
}
