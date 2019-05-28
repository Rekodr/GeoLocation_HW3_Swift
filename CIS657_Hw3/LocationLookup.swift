//
//  LocationLookup.swift
//  CIS657_Hw3
//
//  Created by Recodeo Rekod on 5/28/19.
//  Copyright © 2019 Recodeo Rekod. All rights reserved.
//

import Foundation

struct LocationLookup {
    var origLat: Double
    var origLng: Double
    var destLat: Double
    var destLng: Double
    var timeStamp: Date
    init(origLat:Double, origLng:Double, destLat:Double, destLng:Double, timeStamp:Date){
        self.origLat = origLat
        self.origLng = origLng
        self.destLat = destLat
        self.destLng = destLng
        self.timeStamp = timeStamp
    }
}
