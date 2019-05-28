//
//  GeoCalcTextField.swift
//  CIS657_Hw3
//
//  Created by Recodeo Rekod on 5/28/19.
//  Copyright © 2019 Recodeo Rekod. All rights reserved.
//
import UIKit

class GeoCalcTextField: DecimalMinusTextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tintColor = FOREGROUND_COLOR
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.borderStyle = BorderStyle.roundedRect
        self.layer.borderColor = FOREGROUND_COLOR.cgColor
        self.textColor = FOREGROUND_COLOR
        self.backgroundColor = UIColor.clear
        
        guard let ph = self.placeholder else {
            return
        }
        self.attributedPlaceholder = NSAttributedString(string: ph, attributes: [NSAttributedString.Key.foregroundColor: FOREGROUND_COLOR])
    }
}
