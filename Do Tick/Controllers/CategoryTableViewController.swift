//
//  CategoryTableViewController.swift
//  Do Tick
//
//  Created by Ebubechukwu Dimobi on 21.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categories: Results<CategoryItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        
        loadCategories()
        
    }
    
    //MARK: - add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Category to Do Tick", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            // what will happen when user clicks ui alert
            
            if textfield.text != "" {
                
                let newCategory = CategoryItem()
                newCategory.name = textfield.text!
                newCategory.dateCreated = Date()
                
                
                //no need to update categories as Result<categories is autoupdating by itself
                // saving it updates the array and also updates the local persistent data
                self.saveCategories(with: newCategory)
               
                
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
    
    func saveCategories(with category: CategoryItem){
        
        do{
            try realm.write{
                realm.add(category)
            }
        }catch{
            print("error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    //MARK: - load items
    
    func loadCategories(){
        
        categories = realm.objects(CategoryItem.self).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        
        let category = categories?[indexPath.row]
        
        cell.textLabel?.text = category?.name ?? "No Categories added yet"
        
        //convert date to string
        if let date = category?.dateCreated{
            
            let dateFormatter = DateFormatter()

            dateFormatter.dateStyle = .short

            dateFormatter.timeStyle = .none
        
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
       
        
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! DoTickViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = categories?[indexPath.row]
            
        }
    }
    
    
    
}


//MARK: - UISearchBarDelegate
//MARK: - Query from Realm

extension CategoryTableViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        categories = categories?.filter("name CONTAINS[cd]  %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    
    //starts searching once person starts typing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            
            loadCategories()
            //same as  searchBar.endEditing(true)
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadCategories()
        }else {
           categories = categories?.filter("name CONTAINS[cd]  %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
        }
    }
}
