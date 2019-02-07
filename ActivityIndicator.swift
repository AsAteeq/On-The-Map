//
//  File.swift
//  On the map
//
//  Created by Osiem Teo on 13/05/1440 AH.
//  Copyright © 1440 Asma. All rights reserved.
//


import UIKit

struct ActivityIndicator {
    
    private static var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    static func startActivityIndicator(view:UIView){
        
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    
    static func stopActivityIndicator(){
        activityIndicator.stopAnimating()
    }
    
}
