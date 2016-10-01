//
//  File.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/1/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation

struct YearResponse {
    
    let year:Int
    
    let flag:Bool
    
    let date:NSDate?
    
    init(year: Int, flag: Bool, date: NSDate?){
        
        self.year = year
        self.flag = flag
        self.date = date
    }
}

//MARK: Extensions

extension YearResponse: CustomStringConvertible{
    var description: String{
        
        if flag {
            return "You are a tax resident."
        }
        else{
            return "You are not a tax resident."
        }
    }
}
