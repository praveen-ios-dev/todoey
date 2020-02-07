//
//  ViewController.swift
//  todoey
//
//  Created by Kumar Praveen on 19/01/20.
//  Copyright © 2020 kumar paveen. All rights reserved.
//

import UIKit
import CoreData

class TodoeyViewController: UITableViewController {
    
    //var dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("item.plist")
    
    var itemArray = [item]()
    let contextdata = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loaditem()
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell",for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveitem()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("Deleted")
            self.contextdata.delete(itemArray[indexPath.row])
            self.itemArray.remove(at: indexPath.row)
            self.saveitem()
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func addItemButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new todoey", message: nil, preferredStyle: .alert)
        let actions = UIAlertAction(title: "Add Item", style: .default, handler: { (UIAlertAction) in
            
            let newitem = item(context: self.contextdata)
            newitem.title = textField.text!
            if !newitem.title!.isEmpty{
                self.itemArray.append(newitem)
            }
            self.saveitem()
            self.tableView.reloadData()
        })
        alert.addTextField { (alerttextField) in
            alerttextField.placeholder = "Create new item"
            textField = alerttextField
        }
        
        let action2 = UIAlertAction(title: "cancle", style: .destructive) { (UIAlertAction) in
            
        }
        alert.addAction(action2)
        alert.addAction(actions)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveitem(){
        do{
            // core datea create operation
            try contextdata.save()
        }catch{
            print("error saving contex\(error)")
        }
    }
    
    func loaditem(with request: NSFetchRequest<item> = item.fetchRequest()){
        do{
            // core data Read/Fetch operation
            itemArray = try contextdata.fetch(request)
        }catch{
            print("error msg is \(error)")
        }
        tableView.reloadData()
        
    }
    
}

extension TodoeyViewController : UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<item> = item.fetchRequest()
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loaditem(with: request)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loaditem()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
}


