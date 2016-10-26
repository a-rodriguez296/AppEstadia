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
        let locale = NSLocale.current
        let countryArray = NSLocale.isoCountryCodes
        var unsortedCountryArray = Array<(String, String)>()
        for countryCode in countryArray {
            let displayNameString = locale.localizedString(forCurrencyCode: countryCode)
            if displayNameString != nil {
                let tuple = (displayNameString!, countryCode)
                unsortedCountryArray.append(tuple)
            }
        }
        return unsortedCountryArray.sorted(by: { (tuple1, tuple2) -> Bool in
            return tuple1.0 < tuple2.0
        })
    }()
    
    var filteredCountriesArray:[(String, String)] = Array<(String, String)>()
    
    
    init(){}
    
    
    func filterCountriesWithText(_ text: String){
        
        filteredCountriesArray = countriesArray.filter({ (countryName, _) -> Bool in
            return countryName.contains(text) || countryName.lowercased().contains(text)
        })
    }
    
    //This flag represents if the search controller is active
    func countryTupleWithFlag(_ flag: Bool, indexPath: IndexPath) -> (String, String){
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
