//
//  CategoryViewController.swift
//  todoey
//
//  Created by Kumar Praveen on 07/02/20.
//  Copyright © 2020 kumar paveen. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    var catgoryArray = [Category]()
    let contextdata = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loaditem()
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = catgoryArray[indexPath.row].name
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.tableFooterView?.isHidden = true
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return catgoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            self.contextdata.delete(catgoryArray[indexPath.row])
            self.catgoryArray.remove(at: indexPath.row)
            self.saveitem()
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        //        if editingStyle == .insert{
        //            tableView.beginUpdates()
        //            tableView.insertRows(at: [IndexPath(row: catgoryArray.count-1, section: 0)], with: .automatic)
        //            tableView.endUpdates()
        //            addAlert()
        //        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gobutton", sender: self)
        
        
        
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "TodoeyViewController") as! TodoeyViewController
//        nextViewController.navigationItem.title = catgoryArray[indexPath.row].name
//        self.show(nextViewController, sender: Any?.self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoeyViewController
    }
    
    func saveitem(){
        do{
            // core datea create operation
            try contextdata.save()
        }catch{
            print("error saving contex\(error)")
        }
    }
    
    func loaditem(){
        do{
            // core data Read/Fetch operation
            catgoryArray = try contextdata.fetch(Category.fetchRequest())
        }catch{
            print("error msg is \(error)")
        }
        tableView.reloadData()
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        addAlert()
    }
    
    func addAlert(){
        var textField = UITextField()
        let alert = UIAlertController(title: nil, message: "Add Catagory list", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (UIAlertAction) in
            
            let newitem = Category(context: self.contextdata)
            newitem.name = textField.text!
            if !newitem.name!.isEmpty{
                self.catgoryArray.append(newitem)
            }
            self.saveitem()
            self.tableView.reloadData()
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField { (CatagoryAlertField) in
            CatagoryAlertField.placeholder = "Add New Catagory"
            textField = CatagoryAlertField
        }
        alert.addAction(action)
        alert.addAction(action2)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
}
