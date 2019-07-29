//
//  PatientDataTableViewController.swift
//  Malaria_Tool
//
//  Created by Wanzin Yazar on 6/9/19.
//  Copyright © 2019 Wanzin Yazar. All rights reserved.
//

import UIKit

class SelectedPatientDataTableViewController: UITableViewController {
    
    var parasitized : String! = ""
    var uninfected : String! = ""
    var patientName : String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let currCell = indexPath[1]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectedPatientCell", for: indexPath)
        
        var stringCell : String!
        
        // hard coded for now
        if(currCell == 0) {
            stringCell = "Parasitized: " + parasitized
        } else if (currCell == 1) {
            stringCell = "Uninfected: " + uninfected
        } else if (currCell == 2) {
            stringCell = "Patient Name: " + patientName
        }
        
        cell.textLabel?.text = stringCell
        
        return cell
    }

}
