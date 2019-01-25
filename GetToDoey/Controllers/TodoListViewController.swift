//
//  ViewController.swift
//  GetToDoey
//
//  Created by Kenny Anderson on 1/12/19.
//  Copyright © 2019 Kosmic Boo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilesPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    //  let defalts = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        print(dataFilesPath)
        
        
        /*      let newItem = Item()
         newItem.title = "go"
         itemArray.append(newItem)
         
         let newItem2 = Item()
         newItem2.title = "buy"
         itemArray.append(newItem2)
         
         let newItem3 = Item()
         newItem3.title = "make"
         itemArray.append(newItem3)
         
         */
        
        loadItems()
        
        
        //        if let items = defalts.array(forKey: "TodoListArray") as? [Item] {
        //            itemArray = items
        
        //       }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        
        cell.textLabel?.text = item.title
        
        //  Ternary operator
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        //     if item.done == true {
        //         cell.accessoryType = .checkmark
        //      } else {
        //       cell.accessoryType = .none
        
        //   }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItem()
        
        //print(itemArray [indexPath.row])
        
        //     if itemArray[indexPath.row].done == false {
        //          itemArray[indexPath.row].done = true
        //      } else {
        //         itemArray[indexPath.row].done = false
        
        //      }
        
        
        //  if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //      tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //   } else {
        //        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //    }
        
        //   tableView.reloadData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Mark - Add New Items
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Item Catorgory", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
            
            self.saveItem()
            
            //      self.defalts.set(self.itemArray, forKey: "TodoListArray")
            
            
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItem() {
        
        let encoder = PropertyListEncoder()
        
        do {
            
            let data =  try encoder.encode(itemArray)
            try data.write(to: dataFilesPath!)
            
        } catch {
            print("Error encoding item array, \(error)")
            
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilesPath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
                
            } catch {
                
                print("Error decoding item array, \(error)")
            }
            
        }
        
    }
}
