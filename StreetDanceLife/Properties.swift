//
//  Properties.swift
//  StreetDanceLife
//
//  Created by Hiroyuki Yahagi on 2016/10/02.
//  Copyright © 2016年 Hiroyuki Yahagi. All rights reserved.
//

import Foundation

class Properties{
    
    static var settingDic:NSDictionary? = nil
    static let fileName:String = "settings.plist"
    
    public static func getProperties() -> NSDictionary?{
        if(settingDic == nil){
            let filePath = Bundle.main.path(forResource: Properties.fileName, ofType:nil )
            settingDic = NSDictionary(contentsOfFile:filePath!)!
        }
        return settingDic
    }
    
    public static func getProperty(propertyName:String) -> Any?{
        let settingDic:NSDictionary? = Properties.getProperties()
        let keyArr = propertyName.components(separatedBy: ".")
        var dic:NSDictionary? = settingDic
        for key in keyArr {
            let next = dic?.value(forKey: key) as? NSDictionary
            if next == nil {
                return dic?.value(forKey: key)
            }else{
                dic = next
            }
        }
        return dic
    }
    
    public static func getCategory() -> Category?{
        let ud = UserDefaults.standard
        let categoryName = ud.value(forKey: "defaultCategory") as? String
        if categoryName != nil{
            return CategoryDao.getCategory(name: categoryName!)
        }else{
            return nil
        }
    }
    
    public static func setCategory(category:Category) -> Category?{
        let ud = UserDefaults.standard
        ud.set(category.name, forKey: "defaultCategory")
        return category
    }
}
