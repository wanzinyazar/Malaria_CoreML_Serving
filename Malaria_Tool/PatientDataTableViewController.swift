//
//  PatientDataTableViewController.swift
//  Malaria_Tool
//
//  Created by Wanzin Yazar on 6/9/19.
//  Copyright © 2019 Wanzin Yazar. All rights reserved.
//

import UIKit
import CoreData

class PatientDataTableViewController: UITableViewController {
    
    var patients = [Patient_Data]()
    
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientDataCell", for: indexPath)
        
        cell.textLabel?.text = patients[indexPath.row].patient_name
        
        return cell
    }
    
    
    func loadCategories() {
        
        let request : NSFetchRequest<Patient_Data> = Patient_Data.fetchRequest()
        
        do {
            patients = try context.fetch(request)
        } catch {
            print("Error loading categories. \(error)")
        }
        
        self.tableView.reloadData()
    }

}
