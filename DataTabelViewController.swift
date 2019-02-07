//
//  DataViewController.swift
//  On the map
//
//  Created by Osiem Teo on 15/05/1440 AH.
//  Copyright © 1440 Asma. All rights reserved.
//

import UIKit
import SafariServices

class DataTabelViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var dataTabel: UITableView!
    var usersDataArray = DataArray.shared.usersDataArray
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        getAllUsersData()
    }
    
    
    func getAllUsersData(){
        usersDataArray.removeAll()
        
        ActivityIndicator.startActivityIndicator(view: self.view)
        
        ParseClient.sharedInstance().getAllDataFormUsers { (success, usersData, errorString) in
            
            
            if success {
                
                guard let newUsersData = usersData else {return}
                
                self.usersDataArray = newUsersData as! [Result]
                
                DispatchQueue.main.async {
                    ActivityIndicator.stopActivityIndicator()
                    
                    self.dataTabel.reloadData()
                }
                
            }else {
                DispatchQueue.main.async {
                    ActivityIndicator.stopActivityIndicator()
                }
                Alert.showBasicAlert(on: self, with: errorString!)
                
                
            }
            
        }
        
    }
    
    @IBAction func addLocationTapped(_ sender: Any) {
        ParseClient.sharedInstance().getuserDataByUniqueKey { (success, usersData, errorString) in
            
            if success {
                
                if usersData != nil {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "toAddLocation", sender: nil)
                        
                    }
                }else {
                    Alert.showAlertWithTwoButtons(on: self, with: "User \(UdacityClient.sharedInstance().nickname!) Has Already Posted a Stdent Location. Whould you Like to Overwrite Thier Location?", completionHandlerForAlert: { (action) in
                        
                        self.performSegue(withIdentifier: "toAddLocation", sender: nil)
                        
                    })
                    
                }
                
                
            }else {
                Alert.showBasicAlert(on: self, with: errorString!)
            }
        }
        
        
        
    }
    
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return usersDataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell") as! DataTableViewCell
        
        
        cell.fillCell(usersData: usersDataArray[indexPath.row] as! Result)
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataArray = usersDataArray as! [Result]
        
        if let urlString = dataArray[indexPath.row].mediaURL,
            let url = URL(string: urlString){
            
            if url.absoluteString.contains("http://") || url.absoluteString.contains("https://") {
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true, completion: nil)
            }else {
                
                DispatchQueue.main.async {
                    Alert.showBasicAlert(on: self, with: "Cannot Open , Because it's Not Vailed Website !!")
                }            }
            
        }
    }
    
}


    

    
    



    




