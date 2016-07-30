//
//  ApiManager.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 14/9/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//


import Foundation
import Alamofire
import SWXMLHash

typealias CompletionHandler = (PsiData?, ErrorType?) -> Void

class ApiManager {
    private static let baseURL = "http://api.nea.gov.sg/api/WebAPI/?dataset=psi_update&keyref="
    private static let dateFormat = "yyyyMMddHHmmss"
    
    class func getData(handler: CompletionHandler) {
        Alamofire.request(.GET, baseURL + Config.apiKey)
            .responseXMLDocument { request, response, result in
                // check error
                guard !result.isFailure else {
                    return handler(nil, result.error)
                }
                
                // check response code
                if let res = response {
                    if res.statusCode != 200 {
                        return handler(nil, nil)
                    }
                }
                
                guard let data = result.value else {
                    return handler(nil, nil)
                }
                
                var updateTime: String?
                var psiReadingCollection = [PsiReading]()
                for reginData in data["channel"]["item"]["region"] {
                    let psiReading = PsiReading(region: Region(rawValue: reginData["id"].element!.text!)!)
                    updateTime = reginData["record"].element?.attributes["timestamp"]
                    for reading in reginData["record"].children {
                        let readingType = reading.element!.attributes["type"]!
                        let readingValue = reading.element!.attributes["value"]!
                        psiReading.addReadingWithKey(readingType, value: readingValue)
                    }
                    psiReadingCollection.append(psiReading)
                }
                
                guard let time = updateTime else {
                    return handler(nil, nil) // no time data received, bad request
                }
                
                // format update time
                let formatter = NSDateFormatter()
                formatter.dateFormat = self.dateFormat
                formatter.timeZone = NSTimeZone.localTimeZone()
                let psiData = PsiData(time: formatter.dateFromString(time)!, readings: psiReadingCollection)
                
                return handler(psiData, nil)
        }
    }
}
