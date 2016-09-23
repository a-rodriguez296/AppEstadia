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
        //Case when the dates VC is shown for the fisrt time
        static let insertDatesVCInitialLaunch = "insertDates"
        
        //Case when the add single date is shown for the first time
        static let addDatesInitialLaunch = "addDates"
    }
    
    struct Segues {
        static let addDateSegue = "addDateSegue"
        static let showResultsSegue = "showResultsSegue"
        static let insertDatesSegue = "insertDatesSegue"
        static let forecastingSegue = "forecastingSegue"
        static let yearResultsSegue = "yearResultsSegue"
        static let selectCountrySegue = "selectCountrySegue"
        static let datesParentViewSegue = "datesParentViewSegue"
    }
}