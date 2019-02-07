//
//  File.swift
//  On the map
//
//  Created by Osiem Teo on 15/05/1440 AH.
//  Copyright © 1440 Asma. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    
    
    func authenticateWithViewController<E: Encodable>(_ hostViewController: UIViewController,jsonBody: E, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
       
        
        self.getSession(jsonBody: jsonBody) { (success, sessionID,userID, errorString) in
            
            if success {
                
            
                self.sessionID = sessionID
                self.userID = userID
                
                
                self.getPublicDataForUserID(userID: userID) { (success, nickname, errorString) in
                    
                    if success {
                        print("nickname is: \(nickname)")
                        
                        if let nickname = nickname {
                            self.nickname = "\(nickname)"
                        }
                        
                        
                    }
                    
                    completionHandlerForAuth(success, errorString)
                }
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
        
        
        
        
    }
    
    
    
    
    private func getSession<E: Encodable>( jsonBody:E ,completionHandlerForSession: @escaping (_ success: Bool , _ sessionID: String?,_ userID: String?, _ errorString: String?) -> Void) {
       
        _ = taskForPOSTMethod(Methods.AuthenticationSession, decode: UdacitySissResponse.self, jsonBody: jsonBody) { (result, error) in
            
            if let error = error {
                completionHandlerForSession(false ,nil ,nil,"\(error.localizedDescription) ")
            }else {
                let newResult = result as! UdacitySissResponse
                if let sessionID = newResult.session.id , let userID = newResult.account.key  {
                    completionHandlerForSession(true ,sessionID,userID ,nil)
                    
                }else {
                    completionHandlerForSession(false ,nil ,nil," \(error!.localizedDescription)")
                    
                }
                
                
            }
        }
        
    }
    
    func deleteSession(_ completionHandlerForSession: @escaping (_ success: Bool , _ sessionID: String?, _ errorString: String?) -> Void) {
        
        
        _ = taskForDeleteMethod(Methods.AuthenticationSession, decode: SessionDelete.self, completionHandlerForDelete: { (result, error) in
            
            if let error = error {
                completionHandlerForSession(false ,nil,"\(error.localizedDescription) ")
            }else {
                let newResult = result as! SessionDelete
                if let sessionID = newResult.session.id  {
                    completionHandlerForSession(true ,sessionID ,nil)
                    
                }else {
                    completionHandlerForSession(false ,nil ," \(error!.localizedDescription)")
                    
                }
                
                
            }
        }
        )
    }
    private func getPublicDataForUserID(userID: String?,_ completionHandlerForUserID: @escaping (_ success: Bool,_ nickname: String?, _ errorString: String?) -> Void) {
        
        
        var mutableMethod: String = Methods.AuthenticationGetPublicDataForUserID
        mutableMethod = substituteKeyInMethod(mutableMethod, key: UdacityClient.URLKeys.UserID, value: String(UdacityClient.sharedInstance().userID!))!
        
        
        _ = taskForGETMethod(mutableMethod , decode: UdacityUserData.self) { (result, error) in
            
            
            if let error = error {
                
                completionHandlerForUserID(false ,nil ,"\(error.localizedDescription)")
            }else {
                let newResult = result as! UdacityUserData
                if let nickname = newResult.nickname  {
                    
                    completionHandlerForUserID(true ,nickname,nil)
                    
                }else {
                    completionHandlerForUserID(false ,nil,"\(String(describing: error?.localizedDescription))")
                    
                }
                
                
            }
        }
        
    }
    
}
