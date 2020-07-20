//
//  ViewController.swift
//  Todoey
//
//  Created by Ebubechukwu Dimobi on 20.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit

class DoTickViewController: UITableViewController {
    
    //user defaults
    let defaults = UserDefaults.standard
    
    var itemArray = ["Dind Mike", "car", "love"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //using user defaults to retrieve data locally
        if let  items = defaults.array(forKey: "TodoListArray") as? [String]{
            itemArray = items
        }
        
        
    }
    //MARK: - add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add New Do Tick Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
              // what will happen when user clicks ui alert
            
            if textfield.text != nil{
                self.itemArray.append(textfield.text!)
                
                //using user defaults to add data locally
                self.defaults.set(self.itemArray, forKey: "TodoListArray")
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
    
  
   
    
}
//MARK: - TableView Datasource Method

extension DoTickViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
    }
    
    
}


//MARK: - TableView Delegate Method
extension DoTickViewController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            
        }
        tableView.deselectRow(at: indexPath, animated: true)
        print(itemArray[indexPath.row])
    }
    
    
}
