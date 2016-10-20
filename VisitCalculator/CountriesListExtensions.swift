//
//  CountriesListExtensions.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/30/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit

//MARK:UITableViewDataSource
extension CountriesListViewController: UITableViewDataSource{
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.active && !searchController.searchBar.text!.isEmpty{
            return viewModel.filteredCountriesArray.count
        }
        else{
            return viewModel.countriesArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let searchControllerFlag = searchController.active && !searchController.searchBar.text!.isEmpty
        let cell = tableView.dequeueReusableCellWithIdentifier(Constants.Cells.Countries.countriesCell) as! CountriesCell
        cell.initializeWithCountryName(viewModel.countryTupleWithFlag(searchControllerFlag, indexPath: indexPath).0)
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension CountriesListViewController: UITableViewDelegate{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let searchControllerFlag = searchController.active && !searchController.searchBar.text!.isEmpty
        
        let tuple = viewModel.countryTupleWithFlag(searchControllerFlag, indexPath: indexPath)
        
        
        delegate?.didSelectCountry(tuple.0, countryCode: tuple.1)
        
        navigationController?.popViewControllerAnimated(true)
        
    }
    
}

//MARK: UISearchResultsUpdating
extension CountriesListViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        
        if !searchText.isEmpty{
            
            viewModel.filterCountriesWithText(searchText)
        }
        tableView.reloadData()
    }
}