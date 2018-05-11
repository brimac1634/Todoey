//
//  Category.swift
//  Todoey
//
//  Created by Brian MacPherson on 10/5/2018.
//  Copyright © 2018 Brian MacPherson. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    
    let items = List<Item>()
}
