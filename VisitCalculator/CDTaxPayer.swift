//
//  CDTaxPayer.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/13/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import CoreData


class CDTaxPayer: NSManagedObject {

    convenience init(name: String, rut: String, context: NSManagedObjectContext){

        
        let entity = NSEntityDescription.entityForName(CDTaxPayer.MR_entityName(), inManagedObjectContext: context)
        self.init(entity: entity!, insertIntoManagedObjectContext: context)
        
        self.name = name
        self.rut = rut
        
        stays = nil
    }

}
