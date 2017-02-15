//
//  ApiManager.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 14/9/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//


import Foundation
import Alamofire

typealias CompletionHandler = (PsiData?, Error?) -> Void

class ApiManager {
    private static let baseURL = "https://api.data.gov.sg/v1/environment/psi"
    private static let dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    class func getData(handler: @escaping CompletionHandler) {
        let headers: HTTPHeaders = [
            "api-key": Config.apiKey
        ]

        Alamofire.request(baseURL, headers: headers).validate().responseJSON { response in
            guard response.result.isSuccess else {
                return handler(nil, response.error)
            }
            
            if let result = response.result.value {
                let JSON = result as! [String:AnyObject]
                let items = JSON["items"] as! NSArray
                let data = items[0] as! [String:AnyObject]
                let time = data["timestamp"] as! String
                let readings = data["readings"] as! [String:AnyObject]
                let threeHrsReadings = readings["psi_three_hourly"] as! [String:AnyObject]
                let twentyFourHrsReadings = readings["psi_twenty_four_hourly"] as! [String:AnyObject]
                
                
                var readingCollection: [PsiReading] = []
                for region in iterateEnum(Region.self) {
                    let regionData = PsiReading(region: region, twentyFourHourlyReading: twentyFourHrsReadings[region.rawValue] as! Int, threeHourlyReading: threeHrsReadings[region.rawValue] as! Int)
                    readingCollection.append(regionData)
                }
                
                // format update time
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = dateFormat
                formatter.timeZone = TimeZone(identifier: "SGT")
                let psiData = PsiData(time: formatter.date(from: time)!, readings: readingCollection)
                
                return handler(psiData, nil)
            }
        }
    }
}
