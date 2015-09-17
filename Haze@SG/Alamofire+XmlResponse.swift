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
            guard let validData = data else {
                let failureReason = "Data could not be serialized. Input data was nil."
                let error = Error.errorWithCode(.DataSerializationFailed, failureReason: failureReason)
                return .Failure(data, error)
            }
            
            let xml = SWXMLHash.parse(validData)
            return .Success(xml)
        }
    }
    
    public func responseXMLDocument(completionHandler: (NSURLRequest?, NSHTTPURLResponse?, Result<XMLIndexer>) -> Void) -> Self {
        return response(responseSerializer: Request.XMLResponseSerializer(), completionHandler: completionHandler)
    }
}