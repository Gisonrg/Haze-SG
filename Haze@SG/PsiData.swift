//
//  PsiData.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 9/15/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Foundation

class PsiData: Printable {
    private(set) var updatedTime: NSDate
    private(set) var readings: [PsiReading]
    
    init(time: NSDate, readings: [PsiReading]) {
        self.updatedTime = time
        self.readings = readings
    }
    
    var description: String {
        get {
            return "\(updatedTime) : \(readings)"
        }
    }
}