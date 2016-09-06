//
//  CDStay.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/6/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord

class CDStay: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    convenience init(name: String, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entityForName(CDStay.MR_entityName(), inManagedObjectContext: context)
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.name = name
        
    }


}
