//
//  ViewController.swift
//  Todoey
//
//  Created by Ebubechukwu Dimobi on 20.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import UIKit

class DoTickViewController: UITableViewController {
    
    
    let itemArray = ["Dind Mike", "car", "love"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
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
