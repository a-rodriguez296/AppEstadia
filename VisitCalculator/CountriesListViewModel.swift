//
//  CountriesListViewModel.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 10/20/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Bond

class CountriesListViewModel {

    let title = NSLocalizedString("Countries", comment: "")
    
    lazy var countriesArray:Array<(String,String)> = {
        let locale = NSLocale.currentLocale()
        let countryArray = NSLocale.ISOCountryCodes()
        var unsortedCountryArray = Array<(String, String)>()
        for countryCode in countryArray {
            let displayNameString = locale.displayNameForKey(NSLocaleCountryCode, value: countryCode)
            if displayNameString != nil {
                let tuple = (displayNameString!, countryCode)
                unsortedCountryArray.append(tuple)
            }
        }
        return unsortedCountryArray.sort({ (tuple1, tuple2) -> Bool in
            return tuple1.0 < tuple2.0
        })
    }()
    
    var filteredCountriesArray:[(String, String)] = Array<(String, String)>()
    
    
    init(){}
    
    
    func filterCountriesWithText(text: String){
        
        filteredCountriesArray = countriesArray.filter({ (countryName, _) -> Bool in
            return countryName.containsString(text) || countryName.lowercaseString.containsString(text)
        })
    }
    
    //This flag represents if the search controller is active
    func countryTupleWithFlag(flag: Bool, indexPath: NSIndexPath) -> (String, String){
        if flag{
            let tuple = filteredCountriesArray[indexPath.row]
            return tuple
        }
        else{
            let tuple = countriesArray[indexPath.row]
            return tuple
        }
    }
}
