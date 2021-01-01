//
//  Category.swift
//  SmartList
//
//  Created by UTKARSH VARMA on 2020-12-31.
//

import Foundation
import RealmSwift
 
class Category:Object{
    @objc dynamic  var name:String = ""
    let items = List<Item>()
}
