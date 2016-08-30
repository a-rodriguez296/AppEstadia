//
//  WWCalendarTimeswift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 8/31/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import Foundation
import WWCalendarTimeSelector

extension WWCalendarTimeSelector{
    
    func addStyleToCalendar(){
        
        optionCurrentDate = NSDate()
        optionButtonTitleDone = "Ok"
        optionButtonFontColorDone =  UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        optionButtonTitleCancel = "Cancel"
        optionButtonFontColorCancel = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        
        
        optionTopPanelFontColor = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        optionTopPanelBackgroundColor  = .whiteColor()
        optionSelectorPanelBackgroundColor = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        
        
        optionCalendarBackgroundColorPastDatesHighlight = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        optionCalendarBackgroundColorTodayHighlight = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        optionCalendarBackgroundColorFutureDatesHighlight = UIColor(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
    }
    
}
