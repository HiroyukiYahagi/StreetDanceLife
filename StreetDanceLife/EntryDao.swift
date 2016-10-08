//
//  EntryDao.swift
//  StreetDanceLife
//
//  Created by Hiroyuki Yahagi on 2016/10/02.
//  Copyright © 2016年 Hiroyuki Yahagi. All rights reserved.
//

import Foundation

class EntryDao {
    
    static private func loadCategorizedEntries(categoryName:String, loadCompleted:@escaping ()->Void?){
        EntityManager.save()
        let category = EntityManager.getAData("Category", keyColumn: "name", key: categoryName) as! Category
        
        if category.lastUpdate?.compare(Date(timeInterval: Properties.getProperty(propertyName: "loadInterval") as! Double, since: Date())) == ComparisonResult.orderedDescending {
            return
        }
        
        CommonUtil.asyncParse("") { (dic) in
            loadCompleted()
        }
    }
    
//    static public func syncLoadCategoriezedEntries(category:Category, page:Int, rankingMode:RankingMode) ->[Entry]{
//        
//        if rankingMode == RankingMode.favorite {
//            return EntryDao.getFavoriteEntry()
//        }
//        
//        var url:String = Properties.getProperty(propertyName: "url.base") as! String
//        url += "?"
//        url += Properties.getProperty(propertyName: "url.catalog") as! String
//        url += "="
//        url += (category.id?.stringValue)!
//        url += "&"
//        url += Properties.getProperty(propertyName: "url.pagenate") as! String
//        url += "="
//        url += String(describing: page*30)
//        if(rankingMode != RankingMode.all){
//            url += "&"
//            url += Properties.getProperty(propertyName: "url.term") as! String
//            url += "="
//            url += String(describing: rankingMode.getNumber()!)
//        }
//
//        var entries:[Entry] = []
//            
//        CommonUtil.parse(url) { (dics) in
//            for dic in dics!{
//                let url = dic.value(forKey: "url") as? String
//                let entry = EntityManager.getAData("Entry", keyColumn: "url", key: url) as! Entry
//                entry.patchEntiry(dic: dic)
//                entries.append(entry)
//            }
//            EntityManager.save()
//            return nil
//        }
//        
//        return entries
//    }
    
    static public func asyncLoadCategoriezedEntries(category:Category, page:Int, rankingMode:RankingMode, completed:@escaping ([Entry]?, _ error:Error?)->Void?){
        
        if rankingMode == RankingMode.favorite {
            completed(EntryDao.getFavoriteEntry(), nil)
            return
        }
        
        var url:String = Properties.getProperty(propertyName: "url.base") as! String
        url += "?"
        url += Properties.getProperty(propertyName: "url.catalog") as! String
        url += "="
        url += (category.id?.stringValue)!
        url += "&"
        url += Properties.getProperty(propertyName: "url.pagenate") as! String
        url += "="
        url += String(describing: page*30)
        if(rankingMode != RankingMode.all){
            url += "&"
            url += Properties.getProperty(propertyName: "url.term") as! String
            url += "="
            url += String(describing: rankingMode.getNumber()!)
        }
        EntityManager.save()
        CommonUtil.asyncParse(url, callback: { (dics, err) -> Void? in
            
            DispatchQueue.main.async(execute: {
                var entries:[Entry] = []
                if(dics == nil){
                    completed(nil, err)
                    return
                }
                for dic in dics!{
                    let url = dic.value(forKey: "url") as? String
                    let entry = EntityManager.getAData("Entry", keyColumn: "url", key: url) as! Entry
                    entry.patchEntiry(dic: dic)
                    entries.append(entry)
                    //EntityManager.save()
                }
                //EntityManager.save()
                completed(entries, nil)
            })
            return nil
        })
    }
    
    static public func getFavoriteEntry() -> [Entry]{
        EntityManager.save()
        return EntityManager.getData("Entry", predicate: NSPredicate(format: "favorite == true"), sorts: [NSSortDescriptor(key: "date", ascending: false)]) as! [Entry]
    }
    
    static public func deleteAll(){
        EntityManager.save()
        EntityManager.deleteAll(entityName: "Entry")
    }
}
