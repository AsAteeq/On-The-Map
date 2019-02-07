//
//  File.swift
//  On the map
//
//  Created by Osiem Teo on 15/05/1440 AH.
//  Copyright © 1440 Asma. All rights reserved.
//

import Foundation

class ParseClient : NSObject {
    
    // MARK: Properties
    
    // shared
    var session = URLSession.shared
    var objectId : String? = nil
    
    
    
    // Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: GET
    
    func taskForGETMethod<D: Decodable>(_ method: String, parameters: [String:AnyObject],decode:D.Type, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        var parametersWithApiKey = parameters
        
        
        
        var request = NSMutableURLRequest(url: tmdbURLFromParameters(parametersWithApiKey, withPathExtension: method))
        
        
        
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForGET(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            guard (error == nil) else {
                sendError("\(error!.localizedDescription)")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, decode:decode,completionHandlerForConvertData: completionHandlerForGET)
            
        }
        task.resume()
        
        return task
        
        
    }
    
    func taskForPOSTMethod<E: Encodable,D:Decodable>(_ method: String,decode:D.Type?, jsonBody: E, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethod", code: 1, userInfo: userInfo))
        }
        
        let request = NSMutableURLRequest(url:tmdbURLFromWithoutParameters(withPathExtension: method))
        
        
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        do{
            let JsonBody = try JSONEncoder().encode(jsonBody)
            request.httpBody = JsonBody
            
            
        } catch{
            sendError("There was an error with your request JSON Body: \(error)")
            
        }
        
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            
            guard (error == nil) else {
                sendError("\(error!.localizedDescription)")
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            self.convertDataWithCompletionHandler(data, decode: decode!, completionHandlerForConvertData: completionHandlerForPOST)
            
        }
        task.resume()
        
        return task
    }
    
    
    func taskForPUTMethod<E: Encodable,D:Decodable>(_ method: String,decode:D.Type?, jsonBody: E, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        
        func sendError(_ error: String) {
            print(error)
            let userInfo = [NSLocalizedDescriptionKey : error]
            completionHandlerForPUT(nil, NSError(domain: "taskForPUTMethod", code: 1, userInfo: userInfo))
        }
        
        let request = NSMutableURLRequest(url:tmdbURLFromWithoutParameters(withPathExtension: method))
        
        
        
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue(ParseClient.Constants.ApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(ParseClient.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        
        do{
            let JsonBody = try JSONEncoder().encode(jsonBody)
            request.httpBody = JsonBody
            
            
        } catch{
            sendError("There was an error with your request JSON Body: \(error)")
            
        }
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            guard (error == nil) else {
                sendError("\(error!.localizedDescription)")
                return
            }
            
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
          
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            self.convertDataWithCompletionHandler(data, decode: decode!, completionHandlerForConvertData: completionHandlerForPUT)
            
        }
        task.resume()
        
        return task
    }
    
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    
    private func convertDataWithCompletionHandler<D: Decodable>(_ data: Data,decode:D.Type, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        
        do {
            let obj = try JSONDecoder().decode(decode, from: data)
            completionHandlerForConvertData(obj as AnyObject, nil)
            
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
    }
    
    // create a URL from parameters
    private func tmdbURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
            
        }
        
        let url:URL?
        let urlString = components.url!.absoluteString
        if urlString.contains("%22:"){
            
            url = URL(string: "\(urlString.replacingOccurrences(of: "%22:", with: "%22%3A"))")
        }else {
            url = components.url!
        }
        
        return url!
    }
    
 
    private func tmdbURLFromWithoutParameters(withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseClient.Constants.ApiScheme
        components.host = ParseClient.Constants.ApiHost
        components.path = ParseClient.Constants.ApiPath + (withPathExtension ?? "")
        
        print(components.url!)
        
        return components.url!
    }
    class func sharedInstance() -> ParseClient {
        struct Singleton {
            static var sharedInstance = ParseClient()
        }
        return Singleton.sharedInstance
    }
}
