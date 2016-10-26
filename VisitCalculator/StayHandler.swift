//
//  StayHandler.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/30/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation

class StayHandler {
    
    static let sharedInstance = StayHandler()
    
    fileprivate var dates:Set<Date>
    fileprivate var stays:Array<Stay>
    
    init() {
        
        dates = Set<Date>()
        stays = Array<Stay>()
    }
    
    func addStay(_ stay:Stay) -> Date? {
        
        let isSuperSet = dates.isDisjoint(with: stay.dates)
        if isSuperSet {
            dates.formUnion(stay.dates)
            addStayToDates(stay)
            postNotification()
            return nil
        }
        else{
            for date in stay.dates {
                if dates.contains(date as Date) {
                    return date as Date
                }
            }
            //This line is never going to be executed
            return nil
        }
    }
    
    func datesCount() -> Int {
        return dates.count
    }
    
    func staysCount() -> Int{
        return stays.count
    }
    
    func staysArray() -> Array<Stay>{
        return stays
    }
    
    func stayAtIndex(_ index:Int) -> Stay{
        return stays[index]
    }
    
    
    func dumpStays(){
        dates.removeAll()
        stays.removeAll()
    }
    
    func deleteStayWithIndex(_ index: Int){
        
        let stay = stays[index]
        
        for date in stay.dates {
            dates.remove(date as Date)
        }
        
        stays.remove(at: index)
        postNotification()
    }
    
    func oldestDate() -> Date{
        //Identify the oldest date and return the begining of the next year of such date.
        return stays.first!.dates.first! as Date
    }
    
    
    //MARK: Helper functions
    
    //////////////////////////////////////////////
    // HELPER FUNCTIONS
    //////////////////////////////////////////////
    
    fileprivate func addStayToDates(_ stay:Stay){
        stays.append(stay)
        
        //Order the array
        stays = stays.sorted()
    }
    
    //NSNotification staysChanged. This notification is used to notify the tab bar either to enable or disable the tabs
    fileprivate func postNotification(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: Constants.NSNotifications.staysChanged), object: nil)

    }
}
