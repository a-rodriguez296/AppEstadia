//
//  TaxPayers.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 10/6/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import Bond
import MagicalRecord

class TaxPayersViewModel {

    let title = NSLocalizedString("Taxpayers", comment: "")
    let alertMessage = NSLocalizedString("Tap on the button +, on the top right, to add taxpayers", comment: "")
    let showInitialAlertFlag = NSUserDefaults.standardUserDefaults().determineFirstTimeWithKey(Constants.NSUserDefaults.addTaxPayersInitialLaunch)
    
    var fetchedResultsController:NSFetchedResultsController
    
    
    init(){
        
        
        //fetchedResultsController initialization
        let cdStaysFetchRequest = NSFetchRequest(entityName: CDTaxPayer.MR_entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        cdStaysFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: cdStaysFetchRequest,
            managedObjectContext: NSManagedObjectContext.MR_defaultContext(),
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            print("An error occurred")
        }
    }
    
    
    
    func numberOfRowsInSection(section: Int) -> Int{
        
        guard let sections = fetchedResultsController.sections else{
            return 0
        }
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> CDTaxPayer{
        return fetchedResultsController.objectAtIndexPath(indexPath) as! CDTaxPayer
    }
    
    func deleteElement(element: CDTaxPayer){
        element.MR_deleteEntityInContext(NSManagedObjectContext.MR_defaultContext())
    }
    
    func updateFetchedResultsPredicateWithText(query: String){
        
         NSFetchedResultsController.deleteCacheWithName("Root")
        if !query.isEmpty{
            let searchPredicate = NSPredicate(format: "(%K CONTAINS[cd] %@) OR (%K CONTAINS %@)","name", query, "id", query)
            fetchedResultsController.fetchRequest.predicate = searchPredicate
        }
        else{
            fetchedResultsController.fetchRequest.predicate = nil
        }
        initializeFetchedResultsController()
    }
    
    func updateAlertFlag(){
        NSUserDefaults.standardUserDefaults().updateValueWithKey(Constants.NSUserDefaults.addTaxPayersInitialLaunch, value: true)
    }
    
    
    //MARK: Helper Methods
    private func initializeFetchedResultsController(){
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            print("An error occurred")
        }
    }
}
