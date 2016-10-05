//
//  Appearance.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/28/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import UIKit

class Appearance {
    
    class func configureAppearance(){
        
        
        //Color de la barra
        UINavigationBar.appearance().barTintColor = UIColor.backgroundYellowColor()
        
        UINavigationBar.appearance().translucent = false
        
        
        //Color de los botones
        UINavigationBar.appearance().tintColor = .whiteColor()
        
        let navBarFont = UIFont(name: Constants.FontNames.SourceSansBold, size: 20)
        
        
        let navBarTitleTextAttributes:NSDictionary = NSDictionary(
            objects: [UIColor.whiteColor(), navBarFont!],
            forKeys: [NSForegroundColorAttributeName, NSFontAttributeName])
        
        
        
        UINavigationBar.appearance().titleTextAttributes = navBarTitleTextAttributes as? [String : AnyObject]
        
        
        //Search Bar
        UITextField.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).backgroundColor = UIColor.lightTextColor()
        UIBarButtonItem.appearanceWhenContainedInInstancesOfClasses([UISearchBar.self]).tintColor = UIColor.detailTextColor()
        
        
        //UISegmentedControl
        UISegmentedControl.appearanceWhenContainedInInstancesOfClasses([ContainerViewController.self]).tintColor = UIColor.backgroundYellowColor()
        let enabledTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.backgroundYellowColor(), NSFontAttributeName:  UIFont(name: Constants.FontNames.SourceSansSemiBold, size: 16)!]
        UISegmentedControl.appearance().setTitleTextAttributes(enabledTitleTextAttributes, forState: .Normal)
        
        let disabledTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.disabledSegmentControlColor(), NSFontAttributeName:  UIFont(name: Constants.FontNames.SourceSansSemiBold, size: 16)!]
        UISegmentedControl.appearance().setTitleTextAttributes(disabledTitleTextAttributes, forState: .Disabled) 
    }
}