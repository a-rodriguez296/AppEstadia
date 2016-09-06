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
        
        //NSNotification staysChanged. This notification is used to notify the tab bar either to enable or disable the tabs
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NSNotifications.staysChanged, object: nil)
    }
    
    func descriptionString() -> String{
//        if dates.count == 0{
//            return ""
//        }
//        else if dates.count == 1 {
//            return DateFormatHelper.mediumDate().stringFromDate(dates.)
//        }
//        else{
//            return "From " + DateFormatHelper.mediumDate().stringFromDate(dates.first!) + " to " + DateFormatHelper.mediumDate().stringFromDate(dates.last!)
//        }
return "hola"
    }
}


