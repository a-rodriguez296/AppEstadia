//
//  Constants.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/2/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation


struct Constants {
    
    struct NSNotifications {
        
        static let staysChanged = "staysChanged"
    }
    
    struct NSUserDefaults {
        
        //Case when the taxpayers list is shown for the first time
        static let addTaxPayersInitialLaunch = "addTaxPayers"
        
        
        //Case when the dates VC is shown for the fisrt time
        static let insertDatesVCInitialLaunch = "insertDates"
        
        //Case when the add single date is shown for the first time
        static let addDatesInitialLaunch = "addDates"
        
        static let countryCode = "countryCode"
        static let countryName = "country"
    }
    
    struct FontNames {
        static let SourceSansSemiBold = "SourceSansPro-Semibold"
        static let SourceSans = "SourceSansPro-Regular"
        static let SourceSansBold = "SourceSansPro-Bold"
    }
    
    struct Cells {
        struct TaxPayer {
            static let taxPayerCell = "TaxPayerCell"
        }
        struct Dates{
            static let datesCell = "DatesCell"
        }
        struct Countries{
            static let countriesCell = "CountriesCell"
        }
        struct YearConclusion {
            static let yearConclusionCell = "YearsConclusionCell"
        }
    }
    
    struct ColorsHex {
        static let yellow = 0xFFE000
    }
}