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
    
    
    convenience init(dates: [NSDate],taxPayer: CDTaxPayer,countryCode: String, context: NSManagedObjectContext){
        
        
        //Construct Dates set
        var datesSet = Set<CDDate>()
        for date in dates{
            
            let cdDate = CDDate(date: date.endOf(.Day ),taxPayer: taxPayer, context: context)
            datesSet.insert(cdDate)
        }
        
        
        
        let entity = NSEntityDescription.entityForName(CDStay.MR_entityName(), inManagedObjectContext: context)
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.dates = datesSet
        initialDate = dates.first!.endOf(.Day)
        endDate = dates.last!.endOf(.Day)
        self.countryCode = countryCode
        self.taxPayer = taxPayer
        
        
        //NSNotification staysChanged. This notification is used to notify the tab bar either to enable or disable the tabs
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.NSNotifications.staysChanged, object: nil)
    }
    
    func descriptionString() -> String{
        if dates!.count == 0 {
            return ""
        }
        else if dates!.count == 1 {
            return DateFormatHelper.mediumDate().stringFromDate(initialDate!)
        }
        else{
            return "From " + DateFormatHelper.mediumDate().stringFromDate(initialDate!) + " to " + DateFormatHelper.mediumDate().stringFromDate(endDate!)
        }
    }
    
    
    //This function is used to fetch the stays associated with a tax payer
    class func staysOrderedByInitialDateWithTaxPayer(taxPayer: CDTaxPayer) -> [CDStay]{
        //fetch only the stays in Colombia, CO is the code for Colombia
        //In the future this value has to be dynamic
        let predicate = NSPredicate(format: "%K = %@ AND %K = %@", "taxPayer", taxPayer, "countryCode", "CO")
        return CDStay.MR_findAllSortedBy("initialDate", ascending: true, withPredicate: predicate) as! [CDStay]
    }
    
    /*
     This function is used to determine if the user has entered stays to either 
     enable or disable the buttons forecasting and summary in insertDatesVC
     */
    class func staysForTaxPayer(taxPayer: CDTaxPayer) -> Int{
        let predicate = NSPredicate(format: "%K = %@", "taxPayer", taxPayer)
        return Int(CDStay.MR_countOfEntitiesWithPredicate(predicate))
    }
}


