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
    let showInitialAlertFlag = UserDefaults.standard.determineFirstTimeWithKey(Constants.NSUserDefaults.insertDatesVCInitialLaunch)
    let okComment = NSLocalizedString("Ok", comment: "")
    let deleteComment = NSLocalizedString("Delete", comment: "")
    
    var fetchedResultsController:NSFetchedResultsController<CDStay>
    
    
    
    init(taxPayer: CDTaxPayer){
        
        //fetchedResultsController initialization
        let cdStaysFetchRequest = NSFetchRequest<CDStay>(entityName: CDStay.mr_entityName())
        cdStaysFetchRequest.predicate = NSPredicate(format: "%K.%K == %@", "taxPayer", "name",taxPayer.name!)
        let primarySortDescriptor = NSSortDescriptor(key: "initialDate", ascending: false)
        cdStaysFetchRequest.sortDescriptors = [primarySortDescriptor]
        
        
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: cdStaysFetchRequest,
            managedObjectContext: NSManagedObjectContext.mr_default(),
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
    
    func numberOfRowsInSection(_ section: Int) -> Int{
        
        guard let sections = fetchedResultsController.sections else{
            return 0
        }
        let currentSection = sections[section]
        return currentSection.numberOfObjects
    }
    
    func objectAtIndexPath(_ indexPath: IndexPath) -> CDStay{
        return fetchedResultsController.object(at: indexPath) 
    }
    
    func deleteElement(_ element: CDStay){
        element.mr_deleteEntity(in: NSManagedObjectContext.mr_default())
    }
    
    func updateAlertFlag(){
        UserDefaults.standard.updateValueWithKey(Constants.NSUserDefaults.insertDatesVCInitialLaunch, value: true)
    }
}
