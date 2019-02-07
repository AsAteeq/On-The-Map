//
//  LocatedViewController.swift
//  On the map
//
//  Created by Osiem Teo on 15/05/1440 AH.
//  Copyright © 1440 Asma. All rights reserved.
//

import UIKit
import MapKit

class LocatedViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var mapString:String?
    var mediaURL:String?
    var latitude:Double?
    var longitude:Double?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        
        createAnnotation()
        
    }
    
    
    
    @IBAction func finishTapped(_ sender: UIButton) {
        if ParseClient.sharedInstance().objectId == nil {
            postNewStudentLocation()
        }else {
            updateStudentLocation()
            
        }
    }
    
    func postNewStudentLocation(){
        
        if let nickname = UdacityClient.sharedInstance().nickname {
            var components = nickname.components(separatedBy: " ")
            if(components.count > 0)
            {
                let firstName = components.removeFirst()
                let lastName = components.joined(separator: " ")
                
                
                let jsonBody = StudentLocationsBody(uniqueKey:UdacityClient.sharedInstance().userID! , firstName:firstName, lastName:lastName ,mapString:mapString!,mediaURL:mediaURL! ,latitude:latitude! , longitude:longitude!)
                
                 ParseClient.sharedInstance().postUserLocation(jsonBody: jsonBody) { (success, errorString) in
                    
                    if success {
                        print(success)
                        
                        self.returnBackToRoot()
                        
                    }else {
                        Alert.showBasicAlert(on: self, with: errorString!.localizedCapitalized)
                    }
                    
                }
            }
            
        }
        
        
    }
    
    func updateStudentLocation(){
        
        if let fullName = UdacityClient.sharedInstance().nickname {
            var components = fullName.components(separatedBy: " ")
            if(components.count > 0)
            {
                let firstName = components.removeFirst()
                let lastName = components.joined(separator: " ")
                
                
                let jsonBody = StudentLocationsBody(uniqueKey:UdacityClient.sharedInstance().userID! , firstName:firstName, lastName:lastName ,mapString:mapString!,mediaURL:mediaURL! ,latitude:latitude! , longitude:longitude!)
                
                
                ParseClient.sharedInstance().putUserLocation(jsonBody: jsonBody) { (success, errorString) in
                    
                    if success {
                        print(success)
                        
                        self.returnBackToRoot()
                    }else {
                        Alert.showBasicAlert(on: self, with: errorString!.localizedCapitalized)
                    }
                    
                }
            }
            
        }
        
        
    }
    
    func returnBackToRoot() {
        DispatchQueue.main.async {
            self.tabBarController?.tabBar.isHidden = false
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
        
    }
    
    func createAnnotation(){
        let annotation = MKPointAnnotation()
        annotation.title = mapString!
        annotation.subtitle = mediaURL!
        annotation.coordinate = CLLocationCoordinate2DMake(latitude!, longitude!)
        self.mapView.addAnnotation(annotation)
        
        
        //zooming to location
        let coredinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coredinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
    }
    
    
}
