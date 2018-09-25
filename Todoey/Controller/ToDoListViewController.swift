//
//  ViewController.swift
//  Todoey
//
//  Created by Gerardo Abril on 9/24/18.
//  Copyright © 2018 Gerardo Abril. All rights reserved.
//

import UIKit
import CoreData

class ToDoViewListController: UITableViewController{

    var itemArray = [Item] ()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))

        //Call this item to load items from Database into app
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
//       Grabs current selected object and updates objects
//       itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        //long version of method above
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//        else{
//            itemArray[indexPath.row].done = false
//        }
        
        /*
         This is how you destroy
         context.delete(itemArray[indexPath.row])
         itemArray.remove(at: indexPath.row)
         */
      

        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //Mark: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField ()
        
        let alert = UIAlertController (title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add Item", style: .default) { (action) in
            
            let newItem = Item (context: self.context)
            newItem.title = textField.text!
            newItem.done = false
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
    
    //Mark: - Save Data
    //This saves any data that is added into the Database
    func saveItems () {
        
        do{ 
            try context.save ()
        }catch{
            print ("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    //Mark: - Load Data
    //This loads the data from the Core Data Database into App
    func loadItems (_ request: NSFetchRequest<Item> = Item.fetchRequest()){
        do{
            itemArray = try context.fetch(request)
        } catch {
            print (error)
        }
    }
    
}

//Mark: - Search bar methods
extension ToDoViewListController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
    
        //[cd] = Case and diacretic sensitive
        request.predicate = NSPredicate (format: "title CONTAINS[cd] %@", searchBar.text!)
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }
}
