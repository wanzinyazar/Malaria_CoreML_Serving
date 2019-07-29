//
//  PatientDataTableViewController.swift
//  Malaria_Tool
//
//  Created by Wanzin Yazar on 6/9/19.
//  Copyright © 2019 Wanzin Yazar. All rights reserved.
//

import UIKit
import Vision
import CoreData

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var patients = [Patient_Data]()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var ParasitizedLabel: UILabel!
    
    @IBOutlet weak var UninfectedLabel: UILabel!
    
    var picker = UIImagePickerController()
    let context = (UIApplication.shared.delegate as!AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        picker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imageView.image = image
            processImage(image: image)
        }
            picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        print("WE IN DIS YO")
        
        var patientTextField = UITextField()
        
        var parasitizedTextField = UITextField()
        
        var uninfectedTextField = UITextField()
        
        let alert = UIAlertController(title: "Add New Patient", message:"Please enter the patients data based on image", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newPatient = Patient_Data(context: self.context)
            
            newPatient.patient_name = patientTextField.text!
            
            newPatient.parasitized = parasitizedTextField.text!
            
            newPatient.uninfected = uninfectedTextField.text!
            
            self.patients.append(newPatient)
            
            self.saveCategories()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Patient Name"
            patientTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "parasitized"
            parasitizedTextField = alertTextField
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "uninfected"
            uninfectedTextField = alertTextField
        }
        
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func processImage(image:UIImage) {
        if let model = try? VNCoreMLModel(for: Malaria().model) {
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if let results = request.results as? [VNClassificationObservation] {
                    for result in results {
                        //print("\(result.identifier): \(result.confidence * 100)%")
                        if result.identifier == "Parasitized" {
                            let resultRounded = Int((result.confidence * 100.0).rounded())
                            self.ParasitizedLabel.text = "\(resultRounded)%"
                        }
                        if result.identifier == "Uninfected" {
                            let resultRounded = Int((result.confidence * 100.0).rounded())
                            self.UninfectedLabel.text = "\(resultRounded)%"
                        }
                    }
                    
                }
            }
            
            if let imageData = image.jpegData(compressionQuality: 1.0) {
                let handler = VNImageRequestHandler(data: imageData, options: [:])
                try? handler.perform([request])
            }
        }
    }

    @IBAction func dataButtonTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "goToData", sender: self)
    }
    
    @IBAction func choosePhotoTapped(_ sender: Any) {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        picker.sourceType = .camera
        present(picker, animated: true, completion: nil)
    }
    
}
