//
//  String+ToDouble.swift
//  Haze@SG
//
//  Created by Refurb iMac 27' on 9/16/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Foundation

extension String {
    func toDouble() -> Double {
        return (self as NSString).doubleValue
    }
}