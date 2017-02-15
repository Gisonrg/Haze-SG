//
//  PsiReading.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 9/15/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Foundation

enum Region: String {
    case North = "north"
    case South = "south"
    case West = "west"
    case East = "east"
    case Central = "central"
    case National = "national"
}

class PsiReading {
    private var region: Region
    private let twentyFourHourlyReading: Int
    private let threeHourlyReading: Int
    
    init(region: Region, twentyFourHourlyReading: Int, threeHourlyReading: Int) {
        self.region = region
        self.twentyFourHourlyReading = twentyFourHourlyReading
        self.threeHourlyReading = threeHourlyReading
    }
    
    func getRegion() -> Region {
        return region
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
        return "\(twentyFourHourlyReading)"
    }
    
    func get3HrsPsi() -> String {
        return "\(threeHourlyReading)"
    }
}
