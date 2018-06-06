//
//  Category.swift
//  Todoey
//
//  Created by Omar AlAli on 6/5/18.
//  Copyright © 2018 Omar AlAli. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name :String = ""
    let items = List<Item>()
}
