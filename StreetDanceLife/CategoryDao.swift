//
//  CategoryDao.swift
//  StreetDanceLife
//
//  Created by Hiroyuki Yahagi on 2016/10/02.
//  Copyright © 2016年 Hiroyuki Yahagi. All rights reserved.
//

import Foundation

class CategoryDao{
    
    static func getCateogies() -> [Category]?{
        
        var categories = EntityManager.getData("Category", predicate: nil, sorts: [NSSortDescriptor(key: "id", ascending: true) ]) as! [Category]
        if(categories.count == 0){
            categories = CategoryDao.loadCategories()
            categories = EntityManager.getData("Category", predicate: nil, sorts: [NSSortDescriptor(key: "id", ascending: true) ]) as! [Category]
        }
        return categories
    }
    
    static func loadCategories() -> [Category]{
        let catDic:NSDictionary = Properties.getProperty(propertyName: "categories") as! NSDictionary
        var categories:[Category] = []
        for (key, value) in catDic {
            let category = EntityManager.getAData("Category", keyColumn: "id", key: nil) as! Category
            category.id = NumberFormatter().number(from: key as! String)
            category.name = value as? String
            categories.append(category)
        }
        EntityManager.save()
        return categories
    }
    
    static func getCategory(name:String) -> Category?{
        EntityManager.save()
        let category = EntityManager.getAData("Category", keyColumn: "name", key: name) as? Category
        return category
    }
    
    static func getKeyCategories() -> [Category]? {
        var categories = EntityManager.getData("Category", predicate: NSPredicate(format: "id != 0"), sorts: [NSSortDescriptor(key: "id", ascending: true) ]) as! [Category]
        if(categories.count == 0){
            categories = CategoryDao.loadCategories()
            categories = EntityManager.getData("Category", predicate: NSPredicate(format: "id != null"), sorts: [NSSortDescriptor(key: "id", ascending: true) ]) as! [Category]
        }
        return categories
    }
}
