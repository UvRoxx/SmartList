//
//  ItemViewController.swift
//  SmartList
//
//  Created by UTKARSH VARMA on 2020-12-31.
//

import UIKit
import RealmSwift
class ItemViewController: UITableViewController {
    var todoItems: Results<Item>?
    let realm = try!Realm()
    var selectedCategory:Category?{
        didSet{
            Load()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier:"itemCell")
        if let items = todoItems?[indexPath.row]{
            cell.textLabel?.text = items.title
            cell.accessoryType = items.done ? .checkmark : .none
            
        }else{
            cell.textLabel?.text = "No Data Found"
        }
        return cell
    }
    
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
        
        var userInput = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (alert) in
            
            if let currentCategory = self.selectedCategory{
                print("Current category found \(currentCategory)")
                do{
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = userInput.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                        print("new item saved \(newItem)")
                    }
                }catch{
                    print(error)
                }
            }
            print("reloaded table view")
            self.tableView.reloadData()
            
            
            
            
        }
        
        
        alert.addTextField { (input) in
            userInput = input
        }
        alert.addAction(action)
        
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let item = todoItems?[indexPath.row]{
            
            do{
                try realm.write{
                    item.done = !item.done
                    self.tableView.reloadData()
                }
            }catch{
                print("error updating item \(error)")
            }
        }
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let deletedItem = todoItems?[indexPath.row]{
                do{
                    try realm.write{
                        realm.delete(deletedItem)
                        self.tableView.reloadData()
                    }
                }catch{
                    print("Error Saving \(error)")
                }
            }
        }
        
}

//MARK:- SAVE AND READ FUNCTIONS

func Load(){
    
    todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
    tableView.reloadData()
}

}

extension ItemViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated")
        tableView.reloadData()
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            Load()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        Load()
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
}
