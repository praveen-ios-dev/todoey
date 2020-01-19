//
//  ViewController.swift
//  todoey
//
//  Created by Kumar Praveen on 19/01/20.
//  Copyright © 2020 kumar paveen. All rights reserved.
//

import UIKit

class TodoeyViewController: UITableViewController {
    
    
    
    var itemArray : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell",for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
           tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
    }
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey", message: nil, preferredStyle: .alert)
        let actions = UIAlertAction(title: "Add Item", style: .default, handler: { (UIAlertAction) in
            self.itemArray.append(textField.text ?? "")
            self.tableView.reloadData()
        })
        alert.addTextField { (alerttextField) in
            alerttextField.placeholder = "Create new item"
            textField = alerttextField
        }
        
        alert.addAction(actions)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
    
    

}




