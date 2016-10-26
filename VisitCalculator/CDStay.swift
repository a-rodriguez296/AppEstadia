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
    
    
    convenience init(dates: [Date],taxPayer: CDTaxPayer,countryCode: String,stayType: Bool,context: NSManagedObjectContext){
        
        
        //Construct Dates set
        var datesSet = Set<CDDate>()
        for date in dates{
            
            let cdDate = CDDate(date: date.endOf(component: .day ),taxPayer: taxPayer, context: context)
            datesSet.insert(cdDate)
        }
        
        
        
        let entity = NSEntityDescription.entity(forEntityName: CDStay.mr_entityName(), in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.dates = datesSet as NSSet?
        initialDate = dates.first!.endOf(component: .day)
        endDate = dates.last!.endOf(component: .day)
        self.countryCode = countryCode
        self.taxPayer = taxPayer
        self.stayType = NSNumber(value: stayType as Bool)
        
        //NSNotification staysChanged. This notification is used to notify the tab bar either to enable or disable the tabs
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NSNotifications.staysChanged), object: nil)
    }
    
    func descriptionString() -> String{
        if dates!.count == 0 {
            return ""
        }
        else if dates!.count == 1 {
            return DateFormatHelper.mediumDate().string(from: initialDate!)
        }
        else{
            return String(format: NSLocalizedString("From %@ to %@", comment: ""), DateFormatHelper.mediumDate().string(from: initialDate!), DateFormatHelper.mediumDate().string(from: endDate!))
        }
    }
    
    func type() -> String{
        
        return stayType == 0 ? NSLocalizedString("Vacations", comment: "") : NSLocalizedString("Business", comment: "")
    }
    
    
    //This function is used to fetch the stays associated with a tax payer
    class func staysOrderedByInitialDateWithTaxPayer(_ taxPayer: CDTaxPayer) -> [CDStay]{
        //fetch only the stays in Colombia, CO is the code for Colombia
        //In the future this value has to be dynamic
        let predicate = NSPredicate(format: "%K = %@ AND %K = %@", "taxPayer", taxPayer, "countryCode", "CO")
        return CDStay.mr_findAllSorted(by: "initialDate", ascending: true, with: predicate) as! [CDStay]
    }
    
    /*
     This function is used to determine if the user has entered stays to either 
     enable or disable the buttons forecasting and summary in insertDatesVC
     */
    class func staysForTaxPayer(_ taxPayer: CDTaxPayer) -> Int{
        let predicate = NSPredicate(format: "%K = %@", "taxPayer", taxPayer)
        return Int(CDStay.mr_countOfEntities(with: predicate))
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
       
        //NSNotification staysChanged. This notification is used to notify the tab bar either to enable or disable the tabs
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NSNotifications.staysChanged), object: nil)
    }
}


