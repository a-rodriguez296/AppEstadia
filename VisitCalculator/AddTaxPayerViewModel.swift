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
import ReactiveKit

class AddTaxPayerViewModel{
    
    let firstLastName = Observable<String?>("")
    let id = Observable<String?>("")
    let validData = Observable<Bool>(false)
    
    let popViewController = Observable<Bool>(false)
    
    let title = NSLocalizedString("Add Tax Payer", comment: "")
    
    
    let btnDoneEvent = Observable<Void>()
    
    
    
    
    init(){
        
        //Make sure the name and id have at least one character
        combineLatest(firstLastName, id)
            .map {
                return !($0!.characters.count > 0 && $1!.characters.count > 0)
            }
            .bind(to: validData)
        
        
        
        
        
        _ = btnDoneEvent
            .observeNext { [unowned self] () in
                
                if !self.validData.value{
                    let trimmedName = self.firstLastName.value!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                    let trimmedId = self.id.value!.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
                    _ = CDTaxPayer(name: trimmedName, id: trimmedId, context:NSManagedObjectContext.mr_default())
                    self.popViewController.value = true
                    
                }
        }
    }
}


