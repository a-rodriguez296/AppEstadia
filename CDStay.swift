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
    
    convenience init(name: String,dates: [NSDate], context: NSManagedObjectContext){
        
        
        //Construct Dates set
        var datesSet = Set<CDDate>()
        for date in dates{
            
            let cdDate = CDDate(date: date.endOf(.Day ), context: context)
            datesSet.insert(cdDate)
        }
        
        
        
        let entity = NSEntityDescription.entityForName(CDStay.MR_entityName(), inManagedObjectContext: context)
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.name = name
        self.dates = datesSet
    }


}
