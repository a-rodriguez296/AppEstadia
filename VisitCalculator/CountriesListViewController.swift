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
        
        title = NSLocalizedString("Countries", comment: "")
        
        
        //Initialize searchController
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = nil
        searchController.searchBar.barTintColor = .whiteColor()
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        extendedLayoutIncludesOpaqueBars = false
        
        navigationController?.navigationBar.translucent = true
        
        setupTable()
        
    }
    
    func setupTable(){
        tableView.registerNib(UINib(nibName: Constants.Cells.Countries.countriesCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.Countries.countriesCell)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 43
    }
    
    
    deinit{
        searchController.view.removeFromSuperview()
    }
}

//MARK: Protocol CountriesListProtocol
protocol CountriesListProtocol {
    func didSelectCountry(countryName: String, countryCode: String)
}
