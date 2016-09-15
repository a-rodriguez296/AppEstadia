//
//  CountriesListViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/15/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit

class CountriesListViewController: UIViewController {

    lazy var countriesArray:Array<String> = {
        let locale = NSLocale.currentLocale()
        let countryArray = NSLocale.ISOCountryCodes()
        var unsortedCountryArray:[String] = []
        for countryCode in countryArray {
            let displayNameString = locale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
            if displayNameString != nil {
                unsortedCountryArray.append(displayNameString!)
            }
        }
        return unsortedCountryArray.sort()
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
    }
}

extension CountriesListViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let countryText = countriesArray[indexPath.row]
        
        let cell = UITableViewCell.init(style: .Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = countryText
        
        return cell
    }
}
