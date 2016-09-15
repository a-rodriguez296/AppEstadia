//
//  CountriesListViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/15/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit

class CountriesListViewController: UIViewController {
    
    var filteredCountries:[(String, String)]?
    let searchController = UISearchController(searchResultsController: nil)
    var delegate:CountriesListProtocol?
    
    lazy var countriesArray:Array<(String,String)> = {
        //print(NSBundle.mainBundle().preferredLocalizations.first! as NSString)
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

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        automaticallyAdjustsScrollViewInsets = false
        
        //Initialize searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = nil
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    deinit{
        searchController.view.removeFromSuperview()
    }
}

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
        
        let cell = UITableViewCell.init(style: .Subtitle, reuseIdentifier: "Cell")
        cell.textLabel?.text = countryText
        cell.selectionStyle = .None
        
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

//MARK: Protocol CountriesListProtocol
protocol CountriesListProtocol {
    func didSelectCountry(countryName: String, countryCode: String)
}
