//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Omar AlAli on 6/3/18.
//  Copyright © 2018 Omar AlAli. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray:Results<Category>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        
        
        cell.textLabel?.text = categoryArray?[indexPath.row].name ?? "No Categories Added yet"
        
        
        return cell
        
    }
    
    
    //MARK: - Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
        }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyViewController
        
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    
    //MARK: - Data Manupilation Methods
    
    func save(categotry : Category) {
        
        do {
            try realm.write {
                realm.add(categotry)
            }
        }catch{
            print("Error Saving Context \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    
    
    
    func loadData()  {
        
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    
    
    //MARK: - Add New Categories
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            // what will happen when user click add button
            
            
            let newCategory = Category()
            newCategory.name = textField.text!
            
            
            
            
            self.save(categotry: newCategory)
            
            
            
            self.tableView.reloadData()
        }
        
        
        // to add text field to our alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add New Category"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
        
    }
    
    
    
    
    
    
}
