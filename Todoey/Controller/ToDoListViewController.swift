//
//  ViewController.swift
//  Todoey
//
//  Created by Gerardo Abril on 9/24/18.
//  Copyright © 2018 Gerardo Abril. All rights reserved.
//

import UIKit

class ToDoViewListController: UITableViewController{

    var itemArray = [Item] ()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print (dataFilePath!)

        
        loadItems ()
//        if let items = UserDefaults.array(forKey: "ToDoListArray") as? [Item]{
//            itemArray = items
//        }
    }
    
    //Mark = TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    /*
     This is how to initialize a table view so that the number of rows
     is appropriate to how much the user has added
    */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = item.title
        
        //ternary operator ==>
        //value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    //Mark - TableView Delegate Methods
    
    /*
     This method demonstrates how to add an accessory so that a checkmark will appear
     whenever the user selects a single cell
    */
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print (itemArray[indexPath.row])
        
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        //long version of method above
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//        else{
//            itemArray[indexPath.row].done = false
//        }

        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField ()
        
        let alert = UIAlertController (title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            
            let newItem = Item ()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            self.saveItems()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems () {
        let encoder = PropertyListEncoder()
        
        do{ 
            let data = try encoder.encode(itemArray)
            try data.write (to: dataFilePath!)
        }catch{
            print("Error encoding item array, \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems (){
        if let data = try? Data (contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
                itemArray = try decoder.decode([Item].self, from: data)
            } catch{
                print (error)
            }
        }
    }
}


