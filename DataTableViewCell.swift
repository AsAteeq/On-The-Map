//
//  DataTableViewCell.swift
//  On the map
//
//  Created by Osiem Teo on 15/05/1440 AH.
//  Copyright © 1440 Asma. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    
    func fillCell(usersData: Result) {
        
        if let frist = usersData.firstName , let last = usersData.lastName , let url = usersData.mediaURL {
            
            fullNameLabel.text = "\(frist) \(last)"
            urlLabel.text = "\(url)"
            
        }
    }
}
