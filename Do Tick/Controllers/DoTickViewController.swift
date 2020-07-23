//
//  ViewController.swift
//  Todoey
//
//  Created by Ebubechukwu Dimobi on 20.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import RealmSwift

class DoTickViewController: UITableViewController {
    
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: CategoryItem? {
        
        didSet{
            loadItems()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryCell")
        
    }
    //MARK: - add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Do Tick Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user clicks ui alert
            
            //using coredata
            
            if let currentCategory = self.selectedCategory{
                
                if textfield.text != ""{
                    do{
                        
                        //try to save new data
                        try self.realm.write{
                            
                            let newTodoItem = Item()
                            newTodoItem.title = textfield.text!
                            newTodoItem.done = false
                            newTodoItem.dateCreated = Date()
                            currentCategory.items.append(newTodoItem)
                        }
                    }catch {
                        print("Error saving new items, \(error)")
                    }
                }
                self.tableView.reloadData()
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
    
    
    
    //MARK: - load items
    
    // = means if you don't pass a request parameter it will take a default value
    func loadItems(){
        
        //load data sorted
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        
        tableView.reloadData()
        
    }
    
    
}
//MARK: - TableView Datasource Method

extension DoTickViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! CategoryTableViewCell
        
        if  let item = todoItems?[indexPath.row]{
            
            cell.textLabel?.text = item.title
            
            //Tenary operator ==>
            // Value = condition ? valueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done == true ? .checkmark : .none
        }else {
            
            cell.textLabel?.text = "No Items Added"
        }
        
        
        
        return cell
    }
    
    
}


//MARK: - TableView Delegate Method
extension DoTickViewController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //remember classes is reference not value
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                    
                }
                
            }catch{
                print("Error when changing data\(error)")
                
            }
            
            tableView.reloadData()
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //swipe from right
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let trash = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions:[trash])
    }
    
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction{
        
        
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            if let categoryForDeletion = self.todoItems?[indexPath.row]{
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
    
    
}

//MARK: - UISearchBarDelegate
//MARK: - Query from Realm

extension DoTickViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd]  %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
    }
    
    
    //starts searching once person starts typing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            
            loadItems()
            //same as  searchBar.endEditing(true)
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItems()
        }else {
            todoItems = todoItems?.filter("title CONTAINS[cd]  %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            
            tableView.reloadData()
            
        }
    }
}
