//
//  Alamofire+XmlResponse.swift
//  Haze@SG
//
//  Created by Jiang Sheng on 9/15/15.
//  Copyright (c) 2015 Gisonrg. All rights reserved.
//

import Foundation
import Alamofire
import SWXMLHash

extension Request {
    public static func XMLResponseSerializer() -> GenericResponseSerializer<XMLIndexer> {
        return GenericResponseSerializer { request, response, data in
            if data == nil {
                return (nil, nil)
            }
            
            let xml = SWXMLHash.parse(data!)
            return (xml, nil)
        }
    }
    
    public func responseXMLDocument(completionHandler: (NSURLRequest, NSHTTPURLResponse?, XMLIndexer?, NSError?) -> Void) -> Self {
        return response(responseSerializer: Request.XMLResponseSerializer(), completionHandler: completionHandler)
    }
}