//
//  Category.swift
//  GetToDoey
//
//  Created by Kenny Anderson on 2/7/19.
//  Copyright © 2019 Kosmic Boo. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
    
}
