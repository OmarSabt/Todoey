//
//  ViewController.swift
//  Todoey
//
//  Created by Omar AlAli on 5/31/18.
//  Copyright © 2018 Omar AlAli. All rights reserved.
//

import UIKit
import RealmSwift

class TodoeyViewController: UITableViewController
{
    
    var todoItems : Results<Item>?
    let realm = try! Realm()

    var selectedCategory : Category? {
        didSet {
          loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
      //  loadData()
    }

    
   
    //MARK - TabelView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row]{
        
        cell.textLabel?.text = item.title
        
        
        // Ternary operator ==>
        // value = conition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType =  item.done == true  ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Item Added"
        }
        
        return cell
        
    }
    
    //MARK - TableView Delegat
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status , \(error)")
            }
        }
        
        tableView.reloadData()

        tableView.deselectRow(at: indexPath, animated: true )
    }
    
    
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            // what will happen when user click add button
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error while saving new item \(error)")
                }
            
            }
           
           
            
            
            self.tableView.reloadData()
        }
        
        
                // to add text field to our alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Creat New Item"
            textField = alertTextField
        }
        
        
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
        
    }
    
    
    
    
    func loadData()  {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated" , ascending: true)
        
        tableView.reloadData()

        }

    
    
}


//MARK: - Search bar methods

extension TodoeyViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems? .filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
    
}



