//
//  Item.swift
//  GetToDoey
//
//  Created by Kenny Anderson on 2/7/19.
//  Copyright © 2019 Kosmic Boo. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
