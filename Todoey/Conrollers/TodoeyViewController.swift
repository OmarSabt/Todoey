//
//  ViewController.swift
//  Todoey
//
//  Created by Omar AlAli on 5/31/18.
//  Copyright © 2018 Omar AlAli. All rights reserved.
//

import UIKit
import CoreData

class TodoeyViewController: UITableViewController
{
    
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var selectedCategory : Category? {
        didSet {
            loadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
    print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadData()
    }

    
   
    //MARK - TabelView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        // Ternary operator ==>
        // value = conition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType =  item.done == true  ? .checkmark : .none
        
        return cell
        
    }
    
    //MARK - TableView Delegat
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        
        //  print( itemArray[ indexPath.row]
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        
        tableView.reloadData()
        
        saveData()

        tableView.deselectRow(at: indexPath, animated: true )
    }
    
    
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
           
            // what will happen when user click add button
            
            
            let newItem = Item(context:self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategorey = self.selectedCategory
           self.itemArray.append(newItem)
            
            self.saveData()
           
            
            
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
    
    func saveData() {
       
        do {
           try context.save()
        }catch{
            print("Error Saving Context \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest() , predicate :NSPredicate? = nil)  {
   
        
        let categotyPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)

        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categotyPredicate , additionalPredicate] )
        } else {
            request.predicate = categotyPredicate
        }
        

        
            do {
               itemArray = try context.fetch(request)
            }catch{
                print("Error fetching data from context \(error)")
            }
        
        tableView.reloadData()
        
        }

    
    
}


//MARK: - Search bar method

extension TodoeyViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate (format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request , predicate: predicate)
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



