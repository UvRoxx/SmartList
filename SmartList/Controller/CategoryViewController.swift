//
//  ViewController.swift
//  SmartList
//
//  Created by UTKARSH VARMA on 2020-12-31.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    let realm = try!Realm()
    var selectedIndex = 0
    var categories:Results<Category>?
    let context = ((UIApplication.shared.delegate)as!AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
load()
    }
//MARK:- Table View Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Entry Added Yet"
        return cell
    }
    //MARK:-Add Function
    
    @IBAction func addButtonClicked(_ sender: UIBarButtonItem) {
        var userInput = UITextField()
        let alert = UIAlertController(title: "New Category", message: "Bhenchod", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (alert) in
            let newCategory = Category()
            if let finalText = userInput.text{
                newCategory.name = finalText
                self.Save(category: newCategory)
                
            }
        }
        alert.addTextField { (input) in
            userInput = input
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
    
//MARK:- Table View Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "showItems", sender: self)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemsVC = segue.destination as! ItemViewController
        itemsVC.selectedCategory = categories?[selectedIndex]
        
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            if let deletedCategory = categories?[indexPath.row]{
                do{
                    try realm.write{
                        realm.delete(deletedCategory)
                        tableView.reloadData()
                        
                    }
                }catch{
                    print("Error Deleting Category \(error)")
                }
            }


        }
    }
//MARK:-Create and Read Functions
    
    func Save(category:Category){
        do {
            try realm.write{
                realm.add(category)
                tableView.reloadData()
            }
        }catch{
            print(error)
        }
    }
    func load(){
       
            categories = realm.objects(Category.self)
      
    }
}

