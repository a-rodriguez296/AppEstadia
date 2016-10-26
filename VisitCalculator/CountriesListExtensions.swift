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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && !searchController.searchBar.text!.isEmpty{
            return viewModel.filteredCountriesArray.count
        }
        else{
            return viewModel.countriesArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let searchControllerFlag = searchController.isActive && !searchController.searchBar.text!.isEmpty
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cells.Countries.countriesCell) as! CountriesCell
        cell.initializeWithCountryName(viewModel.countryTupleWithFlag(searchControllerFlag, indexPath: indexPath).0)
        
        return cell
    }
}

//MARK: UITableViewDelegate
extension CountriesListViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let searchControllerFlag = searchController.isActive && !searchController.searchBar.text!.isEmpty
        
        let tuple = viewModel.countryTupleWithFlag(searchControllerFlag, indexPath: indexPath)
        
        
        delegate?.didSelectCountry(tuple.0, countryCode: tuple.1)
        
        _ = navigationController?.popViewController(animated: true)
        
    }
    
}

//MARK: UISearchResultsUpdating
extension CountriesListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text!
        
        
        if !searchText.isEmpty{
            
            viewModel.filterCountriesWithText(searchText)
        }
        tableView.reloadData()
    }
}
