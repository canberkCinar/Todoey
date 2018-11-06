//
//  Item.swift
//  Todoey
//
//  Created by Canberk Cinar on 11/5/18.
//  Copyright © 2018 Canberk Cinar. All rights reserved.
//

import Foundation

class Item: Encodable ,Decodable
{
    var title : String = ""
    var done : Bool = false
}
