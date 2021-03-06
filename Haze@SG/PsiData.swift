//
//  PsiData.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 9/15/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Foundation

enum ReadingType: String {
    case Psi24hrs = "24hrs"
    case Psi3hrs = "3hrs"
    
    func title() -> String {
        switch(self) {
            case .Psi24hrs:
                return "24-hr PSI"
            case .Psi3hrs:
                return "3-hr PSI"
        }
    }
    
    mutating func toggle() {
        switch(self) {
            case .Psi24hrs:
                self = .Psi3hrs
            case .Psi3hrs:
                self = .Psi24hrs
        }
    }
}

class PsiData {
    private var updatedTime: Date
    private var readings: [PsiReading]
    
    init(time: Date, readings: [PsiReading]) {
        self.updatedTime = time
        self.readings = readings
    }
    
    func getReadings() -> [PsiReading] {
        return readings
    }
    
    func getUpdatedTime() -> Date {
        return updatedTime
    }
    
    func getNationalReading() -> String {
        guard let type = AppConstant.getDefaultReadingType() else {
            return ""
        }
        
        for reading in readings {
            if reading.getRegion() == .National {
                return reading.getReading(type)
            }
        }
        
        return ""
    }
}
