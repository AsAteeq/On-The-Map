//
//  File.swift
//  On the map
//
//  Created by Osiem Teo on 15/05/1440 AH.
//  Copyright © 1440 Asma. All rights reserved.
//

import Foundation
extension UdacityClient {
     struct Constants {
        static let ApiHost = "onthemap-api.udacity.com"
        static let ApiPath = "/v1"
         static let ApiScheme = "https"
        
        
    }
   
    struct URLKeys {
        static let UserID = "id"
    }
    
    struct Methods {
        
        
        static let AuthenticationSession = "/session"
        static let AuthenticationGetPublicDataForUserID = "/users/{id}"
        
        
        
    }
    
    
    
    
}
