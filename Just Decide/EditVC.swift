//
//  EditVC.swift
//  Just Decide
//
//  Created by James Jones on 20/07/2020.
//  Copyright © 2020 James Jones. All rights reserved.
//

import UIKit

class EditVC: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var editSlices: [CarnivalWheel] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
       getSlices()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
   private func getSlices()  {
        PersistenceManager.retrieveSlices { [weak self] result in
            guard let self = self else {return}
            
            switch result {
            case .success(let slices):
                if slices.isEmpty {
                    print("this is where i will add an alert or sumin")
                }else {
                    self.editSlices = slices
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        
                    }
                   
                }
                
            case .failure(let error):
                print("Edit VC Errror ")
            }
        }
    
    }

    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Option", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Option", style: .default) { (action) in
            let newSlice = CarnivalWheel(title: textField.text!)
            
            PersistenceManager.updateWith(slice: newSlice, actionType: .add) { [weak self] error in
                guard let self = self else {return}
                guard let error = error else {
               print("Successs")
                    return
                }
                print("Something went wrong")
            }
            self.getSlices()
            
           
        }
            alert.addTextField { (alertTextFeild) in
                   alertTextFeild.placeholder = "Create New Option"
                   textField = alertTextFeild
               }
               alert.addAction(action)
               
               present(alert, animated: true, completion: nil)
        
    }

   
}



extension EditVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editSlices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let slice = editSlices[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "EditCell") as! EditCell
        cell.setSlices(slice: slice)
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {   // swipe to delete
    guard editingStyle == .delete else {return}
        let slice = editSlices[indexPath.row]
        editSlices.remove(at: indexPath.row)
        
        PersistenceManager.updateWith(slice: slice, actionType: .remove) {[weak self] error in
            guard let self = self else {return}
            
            guard let error = error else {return}
            print("Successfully removed")
            
        }
        self.tableView.reloadData()
    }
}
