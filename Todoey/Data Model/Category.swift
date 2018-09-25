//
//  Category.swift
//  Todoey
//
//  Created by Gerardo Abril on 9/25/18.
//  Copyright © 2018 Gerardo Abril. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
