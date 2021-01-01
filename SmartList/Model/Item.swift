//
//  Item.swift
//  SmartList
//
//  Created by UTKARSH VARMA on 2020-12-31.
//

import Foundation
import RealmSwift
class Item:Object{
   
        @objc dynamic var title:String = ""
        @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated:Date?
        var selectedCategory = LinkingObjects(fromType: Category.self,property:"items")

}
