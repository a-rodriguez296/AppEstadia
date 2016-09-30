//
//  CountriesListExtensions.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/30/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import UIKit

//MARK:UITableViewDataSource
extension CountriesListViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active && !searchController.searchBar.text!.isEmpty{
            return filteredCountries!.count
        }
        else{
            return countriesArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var countryText:String
        
        if searchController.active && !searchController.searchBar.text!.isEmpty{
            let tuple = filteredCountries![indexPath.row]
            countryText = tuple.0
        }
        else{
            let tuple = countriesArray[indexPath.row]
            countryText = tuple.0
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Cells.Countries.countriesCell) as! CountriesCell
        cell.initializeWithCountryName(countryText)
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension CountriesListViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var countryTuple:(String,String)
        
        if searchController.active && !searchController.searchBar.text!.isEmpty{
            let tuple = filteredCountries![indexPath.row]
            countryTuple = tuple
        }
        else{
            let tuple = countriesArray[indexPath.row]
            countryTuple = tuple
        }
        delegate?.didSelectCountry(countryTuple.0, countryCode: countryTuple.1)
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    
}

//MARK: UISearchResultsUpdating
extension CountriesListViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        
        if !searchText.isEmpty{
            
            filteredCountries =  countriesArray.filter({ (countryName, _) -> Bool in
                return countryName.containsString(searchText) || countryName.lowercaseString.containsString(searchText)
            })
        }
        tableView.reloadData()
    }
}