//
//  ViewController.swift
//  Todoey
//
//  Created by Brian MacPherson on 26/4/2018.
//  Copyright © 2018 Brian MacPherson. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Buy a cat"
        itemArray.append(newItem)
        
        if let items = defaults.object(forKey: "ToDoListArray") as? [Item] {
            itemArray = items
            
        }
    }
    
        
        
        
    

    
    //MARK - Tableview Datasource Methods
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        
        // Ternary operator>
        // value = condition ? valueIfTrue : ValueIfFalse
        
        cell.accessoryType = item.isDone ? .checkmark : .none
        
        //Use ternary operator above to represent the coding below. much shorter
//        if item.isDone == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        return cell
    }


    //MARK - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        
        
    }
    
    
    //Slide to delete method
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.itemArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    //MARK - Add new items
    
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
            let newItem = Item()
            newItem.title = textField.text!
            print(newItem.title)
            
            self.itemArray.append(newItem)
            self.tableView.reloadData()
//            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
            
        }
    
    
    
}
