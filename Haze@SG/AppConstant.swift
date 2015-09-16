//
//  AppConstant.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 15/9/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Cocoa

struct AppConstant {
    static let error_message_network = "Something wrong with the Internet connection"
    
    static func statusBarItemAttributeForValue(value: String) -> Dictionary<NSObject, AnyObject> {
        return [NSForegroundColorAttributeName : AppColor.colorForPsi(value.toDouble())]
    }
}

struct AppColor {
    static let backgroundColor = NSColor(netHex:0x95A5A6)
    static let psiGoodLevelColor = NSColor(netHex:0x2ECC71)
    static let psiModerateLevelColor = NSColor(netHex:0x3498DB)
    static let psiUnhealthyLevelColor = NSColor(netHex:0xf39c12)
    static let psiVeryUnhealthyLevelColor = NSColor(netHex:0xE67E22)
    static let psiHazardousLevelColor = NSColor(netHex:0xC0392B)
    
    static func colorForPsi(value: Double) -> NSColor {
        if value <= 50 {
            return psiGoodLevelColor
        } else if value <= 100 {
            return psiModerateLevelColor
        } else if value <= 200 {
            return psiUnhealthyLevelColor
        } else if value <= 300 {
            return psiVeryUnhealthyLevelColor
        } else {
            return psiHazardousLevelColor
        }
    }
}