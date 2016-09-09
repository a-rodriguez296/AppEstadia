//
//  TabBarVC.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/2/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit
import MagicalRecord

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
        
        //Parte CoreData
        dynamicDateTabItem?.enabled =  CDStay.MR_countOfEntities() != 0
        yearResultsTabItem?.enabled = CDStay.MR_countOfEntities() != 0
        
        /*
         Pop Dynamic dates tab to root. The reason to do this is because if dates changes,
         this calculation has to be done again, and has to go over the verification that's done in ChooseCurrentDateController
         (Verify if the user in the selected date is a tax resident)
         */
        
        
        let dynamicDateNavVC = viewControllers![1] as! UINavigationController
        dynamicDateNavVC.popToRootViewControllerAnimated(true)
        
    }
    
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    private func signUpToNotifications(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(updateTabBarItemsState), name: Constants.NSNotifications.staysChanged, object: nil)
    }
}
