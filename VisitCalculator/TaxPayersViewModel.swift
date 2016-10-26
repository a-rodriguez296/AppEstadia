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
    let showInitialAlertFlag = UserDefaults.standard.determineFirstTimeWithKey(Constants.NSUserDefaults.addTaxPayersInitialLaunch)
    
    var fetchedResultsController:NSFetchedResultsController<CDTaxPayer>
    
    
    init(){
        
        
        //fetchedResultsController initialization
        let cdStaysFetchRequest = NSFetchRequest<CDTaxPayer>(entityName: CDTaxPayer.mr_entityName())
        let primarySortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        cdStaysFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: cdStaysFetchRequest,
            managedObjectContext: NSManagedObjectContext.mr_default(),
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            print("An error occurred")
        }
    }
    
    
    
    func numberOfRowsInSection(_ section: Int) -> Int{
        
        guard let sections = fetchedResultsController.sections else{
            return 0
        }
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> CDTaxPayer{
        return fetchedResultsController.object(at: indexPath)
    }
    
    func deleteElement(_ element: CDTaxPayer){
        element.mr_deleteEntity(in: NSManagedObjectContext.mr_default())
    }
    
    func updateFetchedResultsPredicateWithText(_ query: String){
        
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
        UserDefaults.standard.updateValueWithKey(Constants.NSUserDefaults.addTaxPayersInitialLaunch, value: true)
    }
    
    
    //MARK: Helper Methods
    fileprivate func initializeFetchedResultsController(){
        do {
            try fetchedResultsController.performFetch()
        }
        catch {
            print("An error occurred")
        }
    }
}
