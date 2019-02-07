//
//  File.swift
//  On the map
//
//  Created by Osiem Teo on 15/05/1440 AH.
//  Copyright © 1440 Asma. All rights reserved.
//

import Foundation
extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        
    }
    
    
   
    struct URLKeys {
        static let UserID = "id"
        static let ObjectId = "id"
        
    }
    
    
    struct Methods {
        
        static let StudentLocation = "/StudentLocation"
        static let StudentLocationUpdate = "/StudentLocation/{id}"
    }
    
    struct ParameterKeys {
        static let Order = "order"
        static let Limit = "limit"
        static let Where = "where"
        
    }
    
    struct ParameterValues {
        static let Order = "-updatedAt"
        static let Limit = "100"
        static let Where = "{\"uniqueKey\":\"{id}\"}"
        
        
    }
    
    
}
