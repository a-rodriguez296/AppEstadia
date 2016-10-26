//
//  CDDateQueries.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/16/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import MagicalRecord


class CDDateQueries{
    
    
    //This function returns an array of overlaped dates. If none, it returns an empty array
    class func overlapedDatesArrayWithDatesArray(_ datesArray:Array<Date>, taxPayer: CDTaxPayer) -> [CDDate]{
        
        let predicate = NSPredicate(format: "%K IN %@ AND %K = %@ ", "date", datesArray, "taxPayer", taxPayer)
        return CDDate.mr_findAllSorted(by: "date", ascending: true, with: predicate) as! [CDDate]
    }
    
    /*
     This function is exactly the same as the function on top.
     The difference is that this function validates if the overlaped dates are on the country code the user is trying to add a new set of dates
     */
    class func overlapedDatesArrayWithDatesArray(_ datesArray:Array<Date>, taxPayer: CDTaxPayer, countryCode: String) -> [CDDate]{
        
        let predicate = NSPredicate(format: "%K IN %@ AND %K = %@ AND %K = %@ ", "date", datesArray, "taxPayer", taxPayer, "stay.countryCode", countryCode)
        return CDDate.mr_findAllSorted(by: "date", ascending: true, with: predicate) as! [CDDate]
    }
    
    
    class func validateDates(_ datesArray:Array<Date>, taxPayer: CDTaxPayer, countryCode: String) -> (Bool, Date?){
        
        
        //Overlaped dates without country
        let overlapedDates = overlapedDatesArrayWithDatesArray(datesArray, taxPayer: taxPayer)
        
        
        if overlapedDates.isEmpty {
            
            //Se puede agregar estas fechas sin problema
            return (true, nil)
        }
        else{
            
            if overlapedDates.count > 2{
                //No se pueden agregar un stay que tenga más de 2 overlaped dates
                
                return (false, overlapedDates.first!.date! as Date)
            }
                //Este else quiere decir que hay 1 0 2 fechas overlaped, porque el if overlapedDates.isEmpty ya me garantiza que hay más de 0
            else{
                
                let overlapedDatesWithCountry = overlapedDatesArrayWithDatesArray(datesArray, taxPayer: taxPayer, countryCode: countryCode)
                
                //Esto quiere decir que las fechas que estan overlaped son de distintos paises
                if overlapedDatesWithCountry.isEmpty{
                    
                    let newInitialDate = datesArray.first!
                    let newEndDate = datesArray.last!
                    
                    /*
                     Este if quiere decir:
                     si la primera fecha que estoy agregando es el final de una estadia
                     si la ultima fecha que estoy agregando es el principio de una estadia
                     La conjunción de estas clausulas es:
                     La primera fecha que estoy agregando es el final de una estadía y la última fecha que estoy agregando es el principio de una estadía
                     */
                    if CDStayQueries.verifyDateIsInitialDate(newEndDate) ||  CDStayQueries.verifyDateIsFinalDate(newInitialDate){
                        // se puede
                        
                        return (true, nil)
                    }
                    else{
                        /*
                         Esto quiere decir que estoy agregando una estadía de 2 días en diferente país, sobre otra estadía. 
                         Esto no se puede.
                         Ejemplo:
                         Colombia 10-13 Diciembre
                         USA 10-11 Diciembre
                         */
                        return (false, overlapedDates.first!.date! as Date)
                    }
                }
                else{
                    
                    //No se pueden agregar dos fechas en un mismo pais
                    return (false, overlapedDates.first!.date! as Date)
                }
            }
        }
    }
    
    
    class func oldestDateWithTaxPayer(_ taxPayer: CDTaxPayer) -> Date{
        let predicate = NSPredicate(format: "%K = %@","taxPayer", taxPayer)
        let oldestCDDate = CDDate.mr_findFirst(with: predicate, sortedBy: "date", ascending: true)!
        return oldestCDDate.date! as Date
    }
    
    class func newestDateWithTaxPayer(_ taxPayer: CDTaxPayer) -> Date{
        let predicate = NSPredicate(format: "%K = %@","taxPayer", taxPayer)
        let newestDate = CDDate.mr_findFirst(with: predicate, sortedBy: "date", ascending: false)!
        return newestDate.date! as Date
    }
    
    
}




