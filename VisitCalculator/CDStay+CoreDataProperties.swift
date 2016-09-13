//
//  CDStay+CoreDataProperties.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/13/16.
//  Copyright © 2016 ARF. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDStay {

    @NSManaged var endDate: NSDate?
    @NSManaged var initialDate: NSDate?
    @NSManaged var dates: NSSet?
    @NSManaged var taxPayer: CDTaxPayer?

}
