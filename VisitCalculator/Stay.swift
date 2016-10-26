//
//  Stay.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/10/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation

struct Stay {
    
    var dates:Array<Date>
    
    
    
    init(dates: Array<Date>){
        
        self.dates = dates
    }
}


//MARK: Extensions

extension Stay: CustomStringConvertible{
    var description: String{
        if dates.count == 0{
            return ""
        }
        else if dates.count == 1 {
            return DateFormatHelper.mediumDate().string(from: dates.first!)
        }
        else{
            return "From " + DateFormatHelper.mediumDate().string(from: dates.first!) + " to " + DateFormatHelper.mediumDate().string(from: dates.last!)
        }
    }
}

//MARK: Equatable

extension Stay: Equatable{}

func ==(lhs: Stay, rhs: Stay) -> Bool {
    return lhs.dates == rhs.dates
}

//MARK: Comparable
extension Stay: Comparable {}

func < (lhs: Stay, rhs: Stay) -> Bool {
    
    return lhs.dates.first! < rhs.dates.first!
}
