//
//  File.swift
//  On the map
//
//  Created by Osiem Teo on 15/05/1440 AH.
//  Copyright © 1440 Asma. All rights reserved.
//

import Foundation
extension ParseClient {
    
    
    func getAllDataFormUsers(_ completionHandlerForUserID: @escaping (_ success: Bool,_ usersData: [Any]?, _ errorString: String?) -> Void) {
        
        let parameters =  [ParseClient.ParameterKeys.Limit:ParseClient.ParameterValues.Limit,ParseClient.ParameterKeys.Order:ParseClient.ParameterValues.Order]
        
        _ = taskForGETMethod( ParseClient.Methods.StudentLocation, parameters: parameters as [String : AnyObject] , decode: StudentsLocations.self) { (result, error) in
            
            
            if let error = error {
                
                completionHandlerForUserID(false ,nil ,"\(error.localizedDescription)")
            }else {
                let newResult = result as! StudentsLocations
                if let usersData = newResult.results  {
                    completionHandlerForUserID(true ,usersData,nil)
                    
                }else {
                    completionHandlerForUserID(false ,nil ,"\( error!.localizedDescription)")
                    
                }
                
                
            }
        }
        
    }
    
    
    func getuserDataByUniqueKey(_ completionHandlerForUserID: @escaping (_ success: Bool,_ objectId:String?, _ errorString: String?) -> Void) {
        
        
        let method: String = Methods.StudentLocation
        
        let newParameterValues = substituteKeyInMethod(ParseClient.ParameterValues.Where, key: ParseClient.URLKeys.UserID, value: UdacityClient.sharedInstance().userID!)!
        
        
        let parameters =  [ParseClient.ParameterKeys.Where:newParameterValues]
        
        
        /* 2. Make the request */
        
        
        _ = taskForGETMethod(method, parameters: parameters as [String : AnyObject], decode: StudentsLocations.self) { (result, error) in
            
            
            if let error = error {
                
                completionHandlerForUserID(false ,nil ,"\(error.localizedDescription)")
            }else {
                let newResult = result as! StudentsLocations
                
                if !((newResult.results?.isEmpty)!){
                    if let usersData = newResult.results  {
                        
                        if let objectId = usersData[0].objectId    {
                            ParseClient.sharedInstance().objectId = objectId
                            
                            
                        }
                        
                        completionHandlerForUserID(true ,self.objectId,nil)
                    }else {
                        completionHandlerForUserID(false ,nil ,"\( error!.localizedDescription)")
                        
                    }
                    
                }else {
                    completionHandlerForUserID(true ,self.objectId ,nil)
                    
                }
                
                
            }
        }
        
    }
    
    func postUserLocation<E: Encodable>( jsonBody:E ,completionHandlerForSession: @escaping (_ success: Bool , _ errorString: String?) -> Void) {
        
        _ = taskForPOSTMethod(Methods.StudentLocation, decode: StudentLocationsResponse.self, jsonBody: jsonBody) { (result, error) in
            
            if let error = error {
                completionHandlerForSession(false ,"\(error.localizedDescription) ")
            }else {
                if result != nil{
                    completionHandlerForSession(true ,nil)
                    
                }else {
                    completionHandlerForSession(false ," \(error!.localizedDescription)")
                    
                }
                
                
            }
        }
        
    }
    
    func putUserLocation<E: Encodable>( jsonBody:E ,completionHandlerForSession: @escaping (_ success: Bool , _ errorString: String?) -> Void) {
        
        var mutableMethod: String = Methods.StudentLocationUpdate
        mutableMethod = substituteKeyInMethod(mutableMethod, key: URLKeys.ObjectId, value: String(self.objectId!))!
        
        _ = taskForPUTMethod(mutableMethod, decode: StudentLocationsUpdateResponse.self, jsonBody: jsonBody) { (result, error) in
            
            if let error = error {
                completionHandlerForSession(false ,"\(error.localizedDescription) ")
            }else {
                if result != nil {
                    completionHandlerForSession(true  ,nil)
                    
                }else {
                    completionHandlerForSession(false ," \(error!.localizedDescription)")
                    
                }
                
                
            }
        }
        
    }
    
    
    
}


