//
//  ViewController.swift
//  Todoey
//
//  Created by Brian MacPherson on 26/4/2018.
//  Copyright © 2018 Brian MacPherson. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {

    var toDoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    //MARK: - Tableview Datasource Methods
    
    
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return toDoItems?.count ?? 1
        }
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
            
            if let item = toDoItems?[indexPath.row] {
                cell.textLabel?.text = item.title
                // Ternary operator>
                // value = condition ? valueIfTrue : ValueIfFalse
                
                cell.accessoryType = item.isDone ? .checkmark : .none
            } else {
                cell.textLabel?.text = "No items added"
            }

            return cell
        }


    //MARK: - Tableview Delegate Methods
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if let item = toDoItems?[indexPath.row] {
                do {
                    try realm.write {
                        item.isDone = !item.isDone
                    }
                } catch {
                    print("Error saving database, \(error)")
                }
                
                tableView.reloadData()
   
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
    
    
        //Slide to delete method
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {

                if let item = toDoItems?[indexPath.row]{
                    do {
                        try realm.write {
                            realm.delete(item)
                        }
                    } catch {
                        print("Error deleting item, \(error)")
                    }
                    
                    tableView.reloadData()
                }
            }
        }
    
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        //The message that pops up on screen.
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: .alert)
        
        //The text field where you type your entry
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        //The button/action that comes with the alert
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if textField.text?.count != 0 {
                
                if let currentCategory = self.selectedCategory {
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = textField.text!
                            newItem.dateCreated = Date()
                            currentCategory.items.append(newItem)
                        }
                    } catch {
                        print("Error updating the database, \(error)")
                    }
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
            
    }
    
    //MARK: - Model manipulation methods

    
    func loadData() {
        
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: true)
    
        tableView.reloadData()

    }
    
    
    
    
}

//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()

    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           loadData()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        } else {
            toDoItems = toDoItems?.filter("title CONTAINS[cd] %@", searchBar.text).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
        }
    }

   
}

