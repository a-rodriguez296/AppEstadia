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
    
    private var dates:Set<NSDate>
    private var stays:Array<Stay>
    
    init() {
        
        dates = Set<NSDate>()
        stays = Array<Stay>()
    }
    
    func addStay(stay:Stay) -> NSDate? {
        
        let isSuperSet = dates.isDisjointWith(stay.dates)
        if isSuperSet {
            dates.unionInPlace(stay.dates)
            addStayToDates(stay)
            return nil
        }
        else{
            for date in stay.dates {
                if dates.contains(date) {
                    return date
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
    
    func stayAtIndex(index:Int) -> Stay{
        return stays[index]
    }
    
    
    func dumpStays(){
        dates.removeAll()
        stays.removeAll()
    }
    
    func deleteStayWithIndex(index: Int){
        
        let stay = stays[index]
        
        for date in stay.dates {
            dates.remove(date)
        }
        
        stays.removeAtIndex(index)
    }
    
    func oldestDate() -> NSDate{
        //Identify the oldest date and return the begining of the next year of such date.
        return stays.first!.dates.first!
    }
    
    
    //MARK: Helper functions
    
    //////////////////////////////////////////////
    // HELPER FUNCTIONS
    //////////////////////////////////////////////
    
    private func addStayToDates(stay:Stay){
        stays.append(stay)
        
        //Order the array
        stays = stays.sort()
    }
}
