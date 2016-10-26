//
//  CountriesListViewController.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/15/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit

class CountriesListViewController: UIViewController {
    
    
    let searchController = UISearchController(searchResultsController: nil)
    var delegate:CountriesListProtocol?
    
    let viewModel = CountriesListViewModel()

    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        
        //Initialize searchController
        initializeSearchController()
        
        extendedLayoutIncludesOpaqueBars = false
        
        navigationController?.navigationBar.isTranslucent = true
        
        setupTable()
        
    }
    
    func setupTable(){
        tableView.register(UINib(nibName: Constants.Cells.Countries.countriesCell, bundle: nil), forCellReuseIdentifier: Constants.Cells.Countries.countriesCell)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 43
    }
    
    func initializeSearchController(){
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.scopeButtonTitles = nil
        searchController.searchBar.barTintColor = .white
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
    }
    
    
    deinit{
        searchController.view.removeFromSuperview()
    }
}

//MARK: Protocol CountriesListProtocol
protocol CountriesListProtocol {
    func didSelectCountry(_ countryName: String, countryCode: String)
}
