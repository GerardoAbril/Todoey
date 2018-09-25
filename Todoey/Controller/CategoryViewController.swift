//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Gerardo Abril on 9/25/18.
//  Copyright © 2018 Gerardo Abril. All rights reserved.
//

import UIKit
import RealmSwift


class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results <Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories ()

    }
    
    //Mark: - TableView Datasource Methods
    override func tableView (_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)       
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet"
        return cell
    }

    //Mark: - TableView Delegate Methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoViewListController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    //Mark: - Data Manipulation Methods

    func save(_ category: Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print ("Error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadCategories (){
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }

    //Mark: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController (title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction (title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.save(newCategory)
            
        }
        alert.addAction(action)

        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new category"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
}
