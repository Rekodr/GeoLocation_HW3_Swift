//
//  GeoCalcButton.swift
//  CIS657_Hw3
//
//  Created by Recodeo Rekod on 5/28/19.
//  Copyright © 2019 Recodeo Rekod. All rights reserved.
//

import UIKit

class  GeoCalcButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tintColor = BACKGROUND_COLOR
        self.backgroundColor = FOREGROUND_COLOR
        self.layer.cornerRadius = 5.0
    }
}
