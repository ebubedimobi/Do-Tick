//
//  ViewController.swift
//  Todoey
//
//  Created by Ebubechukwu Dimobi on 20.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit
import CoreData

class DoTickViewController: UITableViewController {
    
    
    var itemArray = [Item]()
    
    //creating a file path
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
        
        
        
    }
    //MARK: - add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Do Tick Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen when user clicks ui alert
            
            //using coredata
            
            if textfield.text != ""{
                
                let newItem = Item(context: self.context)
                newItem.title = textfield.text!
                newItem.done = false
                self.itemArray.append(newItem)
                self.saveItems()
                
                
                //self.loadItems()
                
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
    
    
    func saveItems(){
        
        do{
            try context.save()
        }catch{
            print("error saving context \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    // = means if you don't pass a request parameter it will take a default value
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest() ){
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from context")
            
        }
        
        tableView.reloadData()
        
    }
    
}
//MARK: - TableView Datasource Method

extension DoTickViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Tenary operator ==>
        // Value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    
}


//MARK: - TableView Delegate Method
extension DoTickViewController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //change the done property
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        //delete data
        //        context.delete(itemArray[indexPath.row])
        //        itemArray.remove(at: indexPath.row)
        
        
        //a different way to update data in database
        //itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
        self.saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
}

//MARK: - UISearchBarDelegate

extension DoTickViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //search using keyword from text
        let predicate = NSPredicate(format: "title CONTAINS[cd]  %@", searchBar.text!)
        request.predicate = predicate
        
        //sort data
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        loadItems(with: request)
        
        
        
    }
    
    
    
    //starts searching once person starts typing
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0{
            
            
          //same as  searchBar.endEditing(true)
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            loadItems()
            
        }else{
            
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            //search using keyword from text
            let predicate = NSPredicate(format: "title CONTAINS[cd]  %@", searchBar.text!)
            request.predicate = predicate
            
            //sort data
            
            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
            
            request.sortDescriptors = [sortDescriptor]
            
            loadItems(with: request)
            
        }
        
    }
}
