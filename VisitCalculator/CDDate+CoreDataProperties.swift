//
//  CDDate+CoreDataProperties.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/14/16.
//  Copyright © 2016 ARF. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CDDate {

    @NSManaged var date: Date?
    @NSManaged var stay: CDStay?
    @NSManaged var taxPayer: CDTaxPayer?

}
