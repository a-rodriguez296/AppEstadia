//
//  NSUserDefaults.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/8/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation


extension NSUserDefaults{
    
    func determineFirstTimeWithKey(key:String) -> Bool {
        let allreadyLaunched = boolForKey(key)
        if allreadyLaunched  {
            //Not initial launch
            return false
        }
        else {
            //Initial launch
            setBool(true, forKey: key)
            return true
        }
    }
}