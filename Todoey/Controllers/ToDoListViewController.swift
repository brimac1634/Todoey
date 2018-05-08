//
//  ViewController.swift
//  Todoey
//
//  Created by Brian MacPherson on 26/4/2018.
//  Copyright © 2018 Brian MacPherson. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    var selectedCategory : Category? {
        didSet{
            loadData()
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    //MARK: - Tableview Datasource Methods
    
    
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
            
//            Use ternary operator above to represent the coding below. much shorter
//            if item.isDone == true {
//                cell.accessoryType = .checkmark
//            } else {
//                cell.accessoryType = .none
//            }
            return cell
        }


    //MARK: - Tableview Delegate Methods
    
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            //print(itemArray[indexPath.row])
            
        
            itemArray[indexPath.row].isDone = !itemArray[indexPath.row].isDone
            
            updateData()
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
    
    
        //Slide to delete method
        override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {

                context.delete(itemArray[indexPath.row])
                itemArray.remove(at: indexPath.row)
                updateData()
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
                let newItem = Item(context: self.context)
                
                newItem.title = textField.text!
                newItem.isDone = false
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                
                self.updateData()
            }
            
            
       
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
            
        }
    
    //MARK: - Model manipulation methods
    
    func updateData() {
        do {
            try context.save()
        } catch {
            print("Error saving context, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }

        
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context, \(error)")
        }
        tableView.reloadData()

    }
    
    
    
    
}

//MARK: - Search Bar Methods
extension ToDoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        loadSearchResults(search: searchBar.text!)
   
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
           loadData()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        } else {
            loadSearchResults(search: searchBar.text!)
        }
    }
    
    func loadSearchResults(search: String) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", search)
        
        //Sort our results
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        
        loadData(with: request, predicate: predicate)
    }
}

