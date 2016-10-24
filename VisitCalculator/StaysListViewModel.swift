//
//  StaysListViewModel.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 10/10/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import MagicalRecord

class StaysListViewModel {

    let alertMessage = NSLocalizedString("In order for this app to work, you must add the dates you stayed in the country for the last and current year.", comment: "")
    let showInitialAlertFlag = NSUserDefaults.standardUserDefaults().determineFirstTimeWithKey(Constants.NSUserDefaults.insertDatesVCInitialLaunch)
    let okComment = NSLocalizedString("Ok", comment: "")
    let deleteComment = NSLocalizedString("Delete", comment: "")
    
    var fetchedResultsController:NSFetchedResultsController
    
    
    
    init(taxPayer: CDTaxPayer){
        
        //fetchedResultsController initialization
        let cdStaysFetchRequest = NSFetchRequest(entityName: CDStay.MR_entityName())
        cdStaysFetchRequest.predicate = NSPredicate(format: "%K.%K == %@", "taxPayer", "name",taxPayer.name!)
        let primarySortDescriptor = NSSortDescriptor(key: "initialDate", ascending: false)
        cdStaysFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: cdStaysFetchRequest,
            managedObjectContext: NSManagedObjectContext.MR_defaultContext(),
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
    
    func performFetch(){
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
    
    func objectAtIndexPath(indexPath: NSIndexPath) -> CDStay{
        return fetchedResultsController.objectAtIndexPath(indexPath) as! CDStay
    }
    
    func deleteElement(element: CDStay){
        element.MR_deleteEntityInContext(NSManagedObjectContext.MR_defaultContext())
    }
    
    
}
