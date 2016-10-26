//
//  CDStay+CoreDataProperties.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/15/16.
//  Copyright © 2016 ARF. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDStay {

    @NSManaged var countryCode: String?
    @NSManaged var endDate: Date?
    @NSManaged var initialDate: Date?
    @NSManaged var stayType: NSNumber?
    @NSManaged var dates: NSSet?
    @NSManaged var taxPayer: CDTaxPayer?

}
