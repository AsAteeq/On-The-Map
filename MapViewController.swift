//
//  MapViewController.swift
//  On the map
//
//  Created by Osiem Teo on 15/05/1440 AH.
//  Copyright © 1440 Asma. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    private var annotations = [MKPointAnnotation]()
    var usersDataArray = DataArray.shared.usersDataArray
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self 

        // Do any additional setup after loading the view.
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllUsersData()
    }
    
    
    func getAllUsersData(){
        self.usersDataArray.removeAll()
        annotations.removeAll()
        let allAnnotations = self.mapView.annotations
        ActivityIndicator.startActivityIndicator(view: self.view)
        
        ParseClient.sharedInstance().getAllDataFormUsers { (success, usersData, errorString) in
            
            if success {
                
                self.usersDataArray = usersData as! [Result]
                
                self.organizingUsersData(userDataArray: self.usersDataArray as! [Result])
                
                self.stopActivityIdecator()
            }else {
                self.stopActivityIdecator()
                Alert.showBasicAlert(on: self, with: errorString!)
            }
        }
        
    }
    
    
    
    func stopActivityIdecator(){
        DispatchQueue.main.async {
            ActivityIndicator.stopActivityIndicator()
        }
    }
    
    func organizingUsersData(userDataArray:[Result]){
        
        
        for i in userDataArray {
            
            
            if let latitude = i.latitude , let longitude = i.longitude , let first = i.firstName ,let last = i.lastName , let mediaURL = i.mediaURL {
                
                let lat = CLLocationDegrees(latitude)
                let long = CLLocationDegrees(longitude)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                self.annotations.append(annotation)
                
                
                
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(self.annotations)
                ActivityIndicator.stopActivityIndicator()
            
            }
            
            
        }
        
    }
    
    
    
    @IBAction func refreshNewData(_ sender: Any) {
        
        getAllUsersData()
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        
        UdacityClient.sharedInstance().deleteSession { (success, sessionID, errorString) in
            
            DispatchQueue.main.async {
                if success {
                    self.dismiss(animated: true, completion: nil)
                    
                }else {
                    Alert.showBasicAlert(on: self, with: errorString!)
                }
            }
            
        }
        
    }
    
    
    @IBAction func AddUserLocationTapped(_ sender: Any) {
        
        ParseClient.sharedInstance().getuserDataByUniqueKey { (success, objectID, errorString) in
            
            if success {
                if objectID == nil {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toAdd", sender: nil)
                        
                    }
                }else {
                    
                    Alert.showAlertWithTwoButtons(on: self, with: "User \(UdacityClient.sharedInstance().nickname!) Has Already Posted a Stdent Location. Whould you Like to Overwrite Thier Location?", completionHandlerForAlert: { (action) in
                        
                        self.performSegue(withIdentifier: "toAdd", sender: nil)
                        
                    })
                    
                }
                
                
            }else {
                Alert.showBasicAlert(on: self, with: errorString!)
            }
        }
        
    }
    
    
}



extension MapViewController:MKMapViewDelegate{
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .infoDark)
        }
        else {
            pinView!.annotation = annotation
        }
        
        
        return pinView
    }
    
    
    
    func openUrlInSafari(url:URL){
        
        if url.absoluteString.contains("http://"){
            let svc = SFSafariViewController(url: url)
            present(svc, animated: true, completion: nil)
        }else {
            DispatchQueue.main.async {
                Alert.showBasicAlert(on: self, with: "Cannot Open , Because it's Not Vailed Website !!")
            }
        }
        
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            
            if let toOpen = view.annotation?.subtitle! {
                guard let url = URL(string: toOpen) else {return}
                openUrlInSafari(url:url)
                
            }
        }
    }
    
    func mapView(mapView: MKMapView, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == annotationView.rightCalloutAccessoryView {
            guard let newUrl = annotationView.annotation?.subtitle else {return}
            guard let stringUrl = newUrl else {return}
            guard let url = URL(string: stringUrl) else {return}
            openUrlInSafari(url:url)
            
        }
    }
}
