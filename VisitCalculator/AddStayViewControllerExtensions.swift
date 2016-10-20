//
//  AddStayViewControllerExtensions.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 10/5/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import Bond


//MARK: CountriesListProtocol
extension AddStayViewController: CountriesListProtocol{
    
    func didSelectCountry(countryName: String, countryCode: String) {
        viewModel?.selectedCountry.value = Country(countryName: countryName, countryCode: countryCode)
    }
}
