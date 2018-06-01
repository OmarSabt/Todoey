//
//  ViewController.swift
//  Todoey
//
//  Created by Omar AlAli on 5/31/18.
//  Copyright © 2018 Omar AlAli. All rights reserved.
//

import UIKit

class TodoeyViewController: UITableViewController
{
    
    var itemArray = [item]()
   
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    
             loadData()
    }

    
   
    //MARK - TabelView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.titel
        
        
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
            
            let newItem = item()
            newItem.titel = textField.text!
            
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
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch{
            print("Error encoding item Array \(error)")
        }
    }
    
    
    func loadData()  {
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([item].self , from: data)
            }catch{
                print("error decoding it arrat \(error)")
            }
        }
        
    }
    
}



