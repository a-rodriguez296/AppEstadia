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
}
