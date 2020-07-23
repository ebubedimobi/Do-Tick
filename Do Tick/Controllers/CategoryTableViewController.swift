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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
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
        
        checkIfDone()
        
        tableView.reloadData()
        
        
        
    }
    
    func checkIfDone(){
        
        
        
        if categories != nil{
            
            if categories!.count != 0{
                for x in 0 ... categories!.count - 1 {
                    
                    var done = true
                    //print(categories![x])
                    if categories![x].items.count != 0 {
                        
                        for j in 0 ... categories![x].items.count - 1{
                            
                            
                            if categories![x].items[j].done == false{
                                //print(categories![x].items[j].done)
                                done = false
                            }
                            
                            
                        }
                        
                        
                    }
                    else if categories![x].items.count == 0 {
                        done = false
                        
                    }
                    
                    do {
                        try realm.write{
                            
                            categories![x].done = done
                        }
                        
                    }catch{
                        
                        print(error)
                    }
                    
                    
                }
            }
        }
        
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
        if let date = category?.dateCreated {
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateStyle = .short
            
            dateFormatter.timeStyle = .none
            
            cell.dateLabel.text = dateFormatter.string(from: date)
        }
        
        cell.accessoryType = category?.done == true ? .checkmark : .none
        cell.tintColor = .green
        
        
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
    
    //MARK: - swipe action delegate methods
    
    //swipe from right
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trash = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions:[trash])
    }
    
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        
        
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            if let categoryForDeletion = self.categories?[indexPath.row]{
                do{
                    
                    try self.realm.write{
                        
                        self.realm.delete(categoryForDeletion)
                        completion(true)
                    }
                }catch{
                    print("Error while deleting")
                    completion(false)
                }
                
                self.tableView.reloadData()
            }
            
        }
        action.image = UIImage(systemName: "trash")
        action.backgroundColor = .red
        
        return action
        
    }
    
    
    //swipe from left
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let done = doneAction(at: indexPath)
        return UISwipeActionsConfiguration(actions:[done])
    }
    
    func doneAction(at indexPath: IndexPath) -> UIContextualAction{
        
        
        
        let action = UIContextualAction(style: .normal, title: "Done") { (action, view, completion) in
        
            if let categoryForSettingToDone = self.categories?[indexPath.row]{
                if categoryForSettingToDone.done == false {
                    do{
                        
                        try self.realm.write{
                            
                            if categoryForSettingToDone.items.count != 0{
                                for item in categoryForSettingToDone.items{
                                    
                                    item.done = true
                                }
                                categoryForSettingToDone.done = true
                            }
                            completion(true)
                        }
                    }catch{
                        print("Error while deleting")
                        completion(false)
                    }
                    
                    
                    
                }else {
                    do{
                        
                        try self.realm.write{
                            
                            if categoryForSettingToDone.items.count != 0{
                                for item in categoryForSettingToDone.items{
                                    
                                    item.done = false
                                }
                                categoryForSettingToDone.done = false
                            }
                            completion(true)
                        }
                    }catch{
                        print("Error while deleting")
                        completion(false)
                    }
                    
                   
                    
                }
                self.tableView.reloadData()
            }
        }
        
        action.image = categories?[indexPath.row].done == true ? UIImage(systemName: "pencil.slash") : UIImage(systemName: "checkmark")
        
        action.backgroundColor = categories?[indexPath.row].done == true ? .blue : .green
        
        
        return action
        
    }
    
    
    
}


//MARK: - UISearchBarDelegate
//MARK: - Query and search from Realm

extension CategoryTableViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        categories = categories?.filter("name CONTAINS[cd]  %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
    }
    
    
    //starts searching once person starts typing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            
           
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
