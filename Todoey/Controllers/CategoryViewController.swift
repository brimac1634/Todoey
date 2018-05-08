//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Brian MacPherson on 7/5/2018.
//  Copyright © 2018 Brian MacPherson. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoriesArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }
    
    
    //MARK: - Tableview Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoriesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoriesArray[indexPath.row].name
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "Delete List", message: "Are you sure you want to delete the \"\(self.categoriesArray[indexPath.row].name!)\" list?", preferredStyle: .alert)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
                self.context.delete(self.categoriesArray[indexPath.row])
                self.categoriesArray.remove(at: indexPath.row)
                self.updateData()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            }
            
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoriesArray[indexPath.row]
        }
    }
    
    //MARK: - Data Manipulation Methods
    func updateData() {
        do {
            try context.save()
        } catch {
            print("Error saving data, \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData() {
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoriesArray = try context.fetch(request)
        } catch {
            print("Error loading data, \(error)")
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDoey Category", message: "", preferredStyle: .alert)
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Category"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            
            newCategory.name = textField.text
            self.categoriesArray.append(newCategory)
            
            
            self.updateData()
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
   
    
    
    
    
    
}
