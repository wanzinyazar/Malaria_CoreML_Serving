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
        loadPatients()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patients.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "selectedUserData", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! SelectedPatientDataTableViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.parasitized = patients[indexPath.row].parasitized;
            destinationVC.uninfected = patients[indexPath.row].uninfected;
            destinationVC.patientName = patients[indexPath.row].patient_name;
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientDataCell", for: indexPath)
        
        let text = patients[indexPath.row].patient_name
        
        print(text)
        cell.textLabel?.text = patients[indexPath.row].patient_name
        
        return cell
    }
    
    func loadPatients(with request: NSFetchRequest<Patient_Data> = Patient_Data.fetchRequest()) {
        
        do {
            patients = try context.fetch(request)
        } catch {
            print("Error loading categories. \(error)")
        }
        
        self.tableView.reloadData()
    }

}

//MARK: - Search bar methods

extension PatientDataTableViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        print("searching here")

        let request : NSFetchRequest<Patient_Data> = Patient_Data.fetchRequest()

        request.predicate = NSPredicate(format: "patient_name CONTAINS[cd] %@", searchBar.text!)

        request.sortDescriptors = [NSSortDescriptor(key: "patient_name", ascending: true)]

        loadPatients(with: request)

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadPatients()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}
