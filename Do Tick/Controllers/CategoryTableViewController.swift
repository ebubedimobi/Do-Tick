//
//  CategoryTableViewController.swift
//  Do Tick
//
//  Created by Ebubechukwu Dimobi on 21.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
   var categoryArray = [CategoryItem]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
   
    }
    
    //MARK: - add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category to Do Tick", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen when user clicks ui alert
            
            //using coredata
            
            if textfield.text != ""{
                
                let newCategory = CategoryItem(context: self.context)
                newCategory.name = textfield.text!
                self.categoryArray.append(newCategory)
                self.saveCategories()
                
            }
            
        }
        
        //add textfield to ui alert
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textfield = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK: - save items
    
    func saveCategories(){
        
        do{
            try context.save()
        }catch{
            print("error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //MARK: - load items
    
    // = means if you don't pass a request parameter it will take a default value
    func loadCategories(with request: NSFetchRequest<CategoryItem> = CategoryItem.fetchRequest() ){
        do{
            categoryArray = try context.fetch(request)
            
        }catch{
            print("Error fetching data from context")
            
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DoTickViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categoryArray[indexPath.row]
            
        }
    }
    
    
    
}
