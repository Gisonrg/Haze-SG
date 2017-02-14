//
//  AppConstant.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 15/9/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Cocoa

struct AppConstant {
    static let keyForReadingType: String = "ReadingType"
    
    static let timedTaskFrequency: TimeInterval = 60 * 5 // 5 mins, in seconds
    
    static let error_message_network = "Seems something wrong with the Internet connection.\n" +
                                        "Maybe you forget to connect your WiFi?"
    static let error_message_data = "Seems something wrong with the data received.\n" +
                                    "Sorry for the inconvenience caused by NEA :("
    
    static func statusBarItemAttributeForValue(_ value: String) -> Dictionary<String, AnyObject> {
        return [NSForegroundColorAttributeName : AppColor.colorForPsi(value.toDouble())]
    }
    
    static func healthLevelForPsi(_ value: Double) -> String {
        switch value {
            case 0...50:
                return "Good"
            case 51...100:
                return "Moderate"
            case 101...200:
                return "Unhealthy"
            case 201...300:
                return "Very Unhealthy"
            default:
                return "Hazardous"
        }
    }
    
    static func getDefaultReadingType() -> ReadingType? {
        guard let value = UserDefaults.standard.string(forKey: AppConstant.keyForReadingType) else {
            return nil
        }
        
        return ReadingType(rawValue: value)
    }
}

struct AppColor {
    static let backgroundColor = NSColor(netHex:0x95A5A6)
    static let psiGoodLevelColor = NSColor(netHex:0x2ECC71)
    static let psiModerateLevelColor = NSColor(netHex:0x3498DB)
    static let psiUnhealthyLevelColor = NSColor(netHex:0xF1C40F)
    static let psiVeryUnhealthyLevelColor = NSColor(netHex:0xE67E22)
    static let psiHazardousLevelColor = NSColor(netHex:0xC0392B)
    
    static func colorForPsi(_ value: Double) -> NSColor {
        switch value {
        case 0...50:
            return psiGoodLevelColor
        case 51...100:
            return psiModerateLevelColor
        case 101...200:
            return psiUnhealthyLevelColor
        case 201...300:
            return psiVeryUnhealthyLevelColor
        default:
            return psiHazardousLevelColor
        }
    }
}
