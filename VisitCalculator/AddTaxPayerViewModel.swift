//
//  AddTaxPayerViewModel.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 10/6/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import Bond
import MagicalRecord

class AddTaxPayerViewModel{
    
    let firstLastName = Observable<String?>("")
    let id = Observable<String?>("")
    let validData = Observable<Bool>(false)
    
    let popViewController = Observable<Bool>(false)
    
    let title = NSLocalizedString("Add Tax Payer", comment: "")
    
    
    let btnDoneEvent = Observable<Void>()
    
    
    init(){
        
        //Make sure the name and id have at least one character
        combineLatest(firstLastName, id).map {
            return !($0!.characters.count > 0 && $1!.characters.count > 0)
            }.bindTo(validData)
        
        btnDoneEvent.observeNew {[unowned self] () in
            
            let trimmedName = self.firstLastName.value!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let trimmedId = self.id.value!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let _ = CDTaxPayer(name: trimmedName, id: trimmedId, context:NSManagedObjectContext.MR_defaultContext())
            self.popViewController.value = true
        }
    }
}


