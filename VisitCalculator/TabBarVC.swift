//
//  TabBarVC.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/2/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    
    var dynamicDateTabItem:UITabBarItem?
    var yearResultsTabItem:UITabBarItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        //Initialize tab bar items variables
        dynamicDateTabItem = tabBar.items![1]
        yearResultsTabItem = tabBar.items![2]
        
        //Enable or disable tab bar items
        updateTabBarItemsState()
        
        signUpToNotifications()
        
    }
    
    func updateTabBarItemsState(){
        dynamicDateTabItem?.enabled =  StayHandler.sharedInstance.datesCount() != 0
        yearResultsTabItem?.enabled =  StayHandler.sharedInstance.datesCount() != 0
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    private func signUpToNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateTabBarItemsState), name: Constants.NSNotifications.staysChanged, object: nil)
    }
}
