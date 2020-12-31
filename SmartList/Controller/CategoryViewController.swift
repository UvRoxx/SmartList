//
//  ViewController.swift
//  SmartList
//
//  Created by UTKARSH VARMA on 2020-12-31.
//

import UIKit
import CoreData
class CategoryViewController: UITableViewController {
    let categories = [Categories]()
    let context = ((UIApplication.shared.delegate)as!AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()

    }
//MARK:- Table View Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "categoryCell")
        
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    
    
}

