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
        
        UINavigationBar.appearance().isTranslucent = false
        
        
        //Color de los botones
        UINavigationBar.appearance().tintColor = .white
        
        let navBarFont = UIFont(name: Constants.FontNames.SourceSansBold, size: 20)
        
        
        let navBarTitleTextAttributes:NSDictionary = NSDictionary(
            objects: [UIColor.white, navBarFont!],
            forKeys: [NSForegroundColorAttributeName as NSCopying, NSFontAttributeName as NSCopying])
        
        
        
        UINavigationBar.appearance().titleTextAttributes = navBarTitleTextAttributes as? [String : AnyObject]
        
        
        //Search Bar
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.lightText
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.detailTextColor()
        
        
        //UISegmentedControl
        UISegmentedControl.appearance(whenContainedInInstancesOf: [ContainerViewController.self]).tintColor = UIColor.backgroundYellowColor()
        let enabledTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.backgroundYellowColor(), NSFontAttributeName:  UIFont(name: Constants.FontNames.SourceSansSemiBold, size: 16)!]
        UISegmentedControl.appearance().setTitleTextAttributes(enabledTitleTextAttributes, for: UIControlState())
        
        let disabledTitleTextAttributes = [NSForegroundColorAttributeName: UIColor.disabledSegmentControlColor(), NSFontAttributeName:  UIFont(name: Constants.FontNames.SourceSansSemiBold, size: 16)!]
        UISegmentedControl.appearance().setTitleTextAttributes(disabledTitleTextAttributes, for: .disabled) 
    }
}
