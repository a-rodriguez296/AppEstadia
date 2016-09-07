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
    
    convenience init(date: NSDate, context: NSManagedObjectContext){
        
        let entity = NSEntityDescription.entityForName(CDDate.MR_entityName(), inManagedObjectContext: context)
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.date = date
    }
    
    
    
    class func verifyDates(dates:Array<NSDate>) -> NSDate?{
        
        
        //Verify if one of the dates already exist
        
        for date in dates{
            let predicate = NSPredicate(format: "%K == %@", "date", date.endOf(.Day))
            let element = CDDate.MR_findFirstWithPredicate(predicate)
            if element != nil{
                return element!.date
            }
        }
        return nil
    }
    
    class func oldestDate() -> NSDate{
        let oldestCDDate = CDDate.MR_findFirstOrderedByAttribute("date", ascending: true)!
        return oldestCDDate.date!
    }
    
}
