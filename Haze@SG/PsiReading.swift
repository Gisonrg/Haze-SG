//
//  PsiReading.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 9/15/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Foundation

enum Region: String {
    case North = "rNO"
    case South = "rSO"
    case West = "rWE"
    case East = "rEA"
    case Central = "rCE"
    case National = "NRS"
}

class PsiReading: CustomStringConvertible {
    fileprivate let keyFor24HrsPsi = "NPSI"
    fileprivate let keyFor3HrsPsi = "NPSI_PM25_3HR"
    
    fileprivate(set) var region: Region
    fileprivate var readings: Dictionary<String, String> = Dictionary()
    
    init(region: Region) {
        self.region = region
    }
    
    func addReadingWithKey(_ key: String, value: String) {
        readings[key] = value
    }
    
    func getReading(_ type: ReadingType) -> String {
        switch(type) {
            case .Psi24hrs:
                return self.get24HrsPsi()
            case .Psi3hrs:
                return self.get3HrsPsi()
        }
    }
    
    func get24HrsPsi() -> String {
        return readings[keyFor24HrsPsi]!
    }
    
    func get3HrsPsi() -> String {
        return readings[keyFor3HrsPsi]!
    }
    
    var description: String {
        return "\(region.rawValue): \(readings)"
    }
}
