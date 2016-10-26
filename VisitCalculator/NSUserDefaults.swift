//
//  NSUserDefaults.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/8/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation


extension UserDefaults{
    
    func determineFirstTimeWithKey(_ key:String) -> Bool {
        let allreadyLaunched = bool(forKey: key)
        if allreadyLaunched  {
            //Not initial launch
            return false
        }
        else{
            return true
        }
    }
    
    func updateValueWithKey(_ key:String, value:Bool){
        set(value, forKey: key)
        synchronize()
    }
}
