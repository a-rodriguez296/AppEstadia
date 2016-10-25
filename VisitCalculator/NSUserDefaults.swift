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
        else{
            return true
        }
    }
    
    func updateValueWithKey(key:String, value:Bool){
        setBool(value, forKey: key)
        synchronize()
    }
}