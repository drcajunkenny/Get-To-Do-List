//
//  ViewController.swift
//  GetToDoey
//
//  Created by Kenny Anderson on 1/12/19.
//  Copyright © 2019 Kosmic Boo. All rights reserved.
//

import UIKit
import RealmSwift


class TodoListViewController: UITableViewController{
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)))
        
        
        //         let newItem = Item()
        //         newItem.title = "go"
        //         todoItems.append(newItem)
        //
        //         let newItem2 = Item()
        //         newItem2.title = "buy"
        //         todoItems.append(newItem2)
        //
        //         let newItem3 = Item()
        //         newItem3.title = "make"
        //         todoItems.append(newItem3)
        //
        
        //     let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //     loadItems()
        
        
        //        if let items = defalts.array(forKey: "TodoListArray") as? [Item] {
        //            todoItems = items
        
        //       }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //  Ternary operator
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    // next line used to delete instead of check mark in realm
                    //                   realm.delete(item)
                    item.done = !item.done
                }
                
            } catch {
                print("Error saving done status, \(error)")
            }
        }
        
        tableView.reloadData()
        
        // The 2 lines below let user delete cell from screen and core data by touch (order important)
        
        //      context.delete(todoItems[indexPath.row])
        //      todoItems.remove(at: indexPath.row)
        
        
        //     todoItems?[indexPath.row].done = !todoItems[indexPath.row].done
        
        
        //       todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        
        //   saveItem()
        
        //print(todoItems [indexPath.row])
        
        //     if todoItems[indexPath.row].done == false {
        //          todoItems[indexPath.row].done = true
        //      } else {
        //         todoItems[indexPath.row].done = false
        
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
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print ("Error saving the items, \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        
        
        //        let categorypredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //
        //        if let addtionalPredicate = predicate {
        //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categorypredicate, addtionalPredicate])
        //        } else {
        //            request.predicate = categoryPredicate
        //
        //        }
        //
        //
        //        do {
        //            todoItems = try context.fetch(request)
        //        } catch {
        //            print("Error fetching data from context \(error)")
        //        }
        
        tableView.reloadData()
    }
    
    
}

// search bar methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
        
        
        // the next line is for sort by title alphabeticlly in realm
        //        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        //this is core data for search
        //        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //
        //        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        //
        //        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        //
        //        loadItems(with: request, predicate: predicate)
        
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
        
    }
    
}


