//
//  RoundedButton.swift
//  VisitCalculator
//
//  Created by Alejandro Rodriguez on 9/30/16.
//  Copyright © 2016 ARF. All rights reserved.
//

import UIKit

@IBDesignable open class RoundButton: UIButton {
    
    @IBInspectable var borderColor: UIColor = UIColor.white {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 2.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0.0{
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
    }
}
