//
//  UIColor.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/28/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import UIKit


import UIKit


extension UIColor{
    
    class func generateColorWithRGB(_ red: Double,green:Double, blue:Double,alpha:Double) -> UIColor{
        return UIColor(red: CGFloat(red/255.0), green: CGFloat(green/255) , blue: CGFloat (blue/255), alpha: CGFloat(alpha))
    }
    
    class func backgroundYellowColor() -> UIColor{
        return UIColor.generateColorWithRGB(255.0, green: 224.0, blue: 0.0, alpha: 1.0)
    }
    
    class func detailTextColor() -> UIColor{
        return UIColor.generateColorWithRGB(153.0, green: 153.0, blue: 153.0, alpha: 1.0)
    }
    
    class func titleTextColor() -> UIColor{
        return UIColor.generateColorWithRGB(74.0, green: 74.0, blue: 74.0, alpha: 1.0)
    }
    
    class func disabledGrayColor() -> UIColor{
        return UIColor.generateColorWithRGB(130.0, green: 130.0, blue: 130.0, alpha: 1.0)
    }
    
    class func deleteRedColor() -> UIColor{
        return UIColor.generateColorWithRGB(237.0, green: 48.0, blue: 19.0, alpha: 1.0)
    }
    
    class func disabledSegmentControlColor() -> UIColor{
        return UIColor.generateColorWithRGB(230.0, green: 230.0, blue: 230.0, alpha: 1.0)
    }
    
}
