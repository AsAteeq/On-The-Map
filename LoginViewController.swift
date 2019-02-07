//
//  LoginViewController.swift
//  On the map
//
//  Created by Osiem Teo on 05/05/1440 AH.
//  Copyright © 1440 Asma. All rights reserved.
//

import UIKit
import SafariServices

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var loginButten: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
        
        passText.delegate = self
        emailText.delegate = self
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @objc func dismissKeyboard(){
        self.view.endEditing(true)
    }
    override func viewDidDisappear(_ animated: Bool) {
        emailText.text = ""
        passText.text = ""
    }
    
    @IBAction func checkLogin(_ sender: Any) {
        if emailText.text == "" || passText.text == "" {
           
             Alert.showBasicAlert(on :self ,with : "empty ")
            
        }else {
            ActivityIndicator.startActivityIndicator(view: self.loginButten)
            
            guard let username = emailText.text else {return}
            guard let password = passText.text else {return}
            
            let jsonBody = UdacitySessBody(udacity: Udacity(username: username, password: password))
            
            loginButten.isEnabled = false
            
            UdacityClient.sharedInstance().authenticateWithViewController(self, jsonBody: jsonBody) { (success,errorString) in
                DispatchQueue.main.async {
                    if success {
                        self.loginButten.isEnabled = true
                        ActivityIndicator.stopActivityIndicator()
                        self.loginCompelete()
                    }else {
                        self.loginButten.isEnabled = true
                        ActivityIndicator.stopActivityIndicator()
                        Alert.showBasicAlert(on: self, with: errorString!)
                    }
                }
                
            }
        
        }
    }
    private func loginCompelete() {
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "ManagerTabBarController") as! UITabBarController
       
       present(controller, animated: true, completion: nil)
       // self.performSegue(withIdentifier: "goToMainSc", sender: nil)
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}


    



