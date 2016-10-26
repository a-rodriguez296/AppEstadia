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

    convenience init(name: String, id: String, context: NSManagedObjectContext){

        
        let entity = NSEntityDescription.entity(forEntityName: CDTaxPayer.mr_entityName(), in: context)
        self.init(entity: entity!, insertInto: context)
        
        self.name = name
        self.id = id
        
        stays = nil
    }

}
