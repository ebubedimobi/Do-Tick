//
//  Category.swift
//  Do Tick
//
//  Created by Ebubechukwu Dimobi on 21.07.2020.
//  Copyright © 2020 blazeapps. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryItem: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var dateCreated: Date?
    @objc dynamic var done: Bool = false
    let items = List<Item>()
}
