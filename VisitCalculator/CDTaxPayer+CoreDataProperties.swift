//
//  CDTaxPayer+CoreDataProperties.swift
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

extension CDTaxPayer {

    @NSManaged var name: String?
    @NSManaged var id: String?
    @NSManaged var dates: NSSet?
    @NSManaged var stays: NSSet?

}
