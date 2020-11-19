//
//  Reports.swift
//  DemoTestTask
//
//  Created by rlogical-dev-35 on 18/11/20.
//  Copyright © 2020 rlogical-dev-35. All rights reserved.
//

import UIKit
import Foundation
import RealmSwift


func UniquePrimeryKeyForReports(_ id: String) -> String {
    return (id)
}


class Diary: Object
{
    @objc dynamic var id = ""
    @objc dynamic var title = ""
    @objc dynamic var content = ""
    @objc dynamic var date = ""
    @objc dynamic var isSync = ""
    

    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    convenience init (id: String, title: String, content: String, date: String, isSync: String)
    {
        self.init()
        self.id = id
        self.title = title
        self.content = content
         self.date = date
        self.isSync = isSync

    }
    convenience init (object : Diary)
    {
        self.init()
        self.id = object.id
        self.title = object.title
        self.content = object.content
        self.date = object.date
        self.isSync = object.isSync
        
    }
}

