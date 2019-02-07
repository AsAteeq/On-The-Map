//
//  AddLocationViewController.swift
//  On the map
//
//  Created by Osiem Teo on 15/05/1440 AH.
//  Copyright © 1440 Asma. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    @
    IBOutlet weak var yourLocationTextfield: UITextField!
    
    @IBOutlet weak var yourWebsiteTextfield: UITextField!
    
    var latitude : Double?
    var longitude : Double?
    
    override func viewDidLoad() {
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func returnBackToRoot() {
        DispatchQueue.main.async {
            if let navigationController = self.navigationController {
                navigationController.popToRootViewController(animated: true)
            }
        }
    }
    
    
    @IBAction func findLocation(_ sender: UIButton) {
        
        guard let websiteLink = yourWebsiteTextfield.text else {return}
        
        if !websiteLink.contains("http://")  &&  !websiteLink.contains("https://")  {
            Alert.showBasicAlert(on: self, with: "The Website Should Contain http:// or https://")
        }else {
            if yourLocationTextfield.text != "" && yourWebsiteTextfield.text != "" {
                
                ActivityIndicator.startActivityIndicator(view: self.view )
                
                let searchRequest = MKLocalSearch.Request()
                searchRequest.naturalLanguageQuery = yourLocationTextfield.text
                
                let activeSearch = MKLocalSearch(request: searchRequest)
                
                activeSearch.start { (response, error) in
                    
                    if error != nil {
                        ActivityIndicator.stopActivityIndicator()
                        
                        print("Location Error : \(error!.localizedDescription)")
                        Alert.showBasicAlert(on: self, with: "Location Not Found")
                    }else {
                        ActivityIndicator.stopActivityIndicator()
                        
                        self.latitude = response?.boundingRegion.center.latitude
                        self.longitude = response?.boundingRegion.center.longitude
                        
                        self.performSegue(withIdentifier: "toLocated", sender: nil)
                    }
                }
            }else {
                DispatchQueue.main.async {
                    
                    Alert.showBasicAlert(on: self, with: "You need to enter your Location & your URL ! ")
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toLocated"{
            let vc = segue.destination as! LocatedViewController
            
            vc.mapString = yourLocationTextfield.text
            vc.mediaURL = yourWebsiteTextfield.text
            vc.latitude = self.latitude
            vc.longitude = self.longitude
            
        }
        
    }
    
    
}

extension AddLocationViewController: UITextFieldDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


