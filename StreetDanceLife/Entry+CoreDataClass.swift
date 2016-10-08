//
//  Entry+CoreDataClass.swift
//  StreetDanceLife
//
//  Created by Hiroyuki Yahagi on 2016/10/02.
//  Copyright © 2016年 Hiroyuki Yahagi. All rights reserved.
//

import UIKit
import CoreData


public class Entry: NSManagedObject {
    
    internal func getImageData(_ complete:@escaping ((UIImage)?)->Void) -> UIImage?{
        if(self.imageData == nil){
            CommonUtil.getContentsFromUrl(self.imageUrl, complete: { (data, response, error) in
                if(data == nil){
                    return nil
                }
                self.imageData = data as NSData?
                let uiImage:UIImage = UIImage(data: data!)!
                complete(uiImage)
                return nil
            })
//            return UIImage(named: Properties.getProperty(propertyName: ("NoImage")) as! String )
            return UIImage()
        }else{
            let uiImage:UIImage = UIImage(data: self.imageData! as Data)!
            return uiImage
        }
    }
    
    internal func patchEntiry(dic:NSDictionary){
        let imageUrl = dic.value(forKey: "thumbnail") as? [String]
        if imageUrl != nil && (imageUrl?.count)! >= 0 && self.imageUrl == nil {
            self.imageUrl = imageUrl?[0]
        }
        self.url = dic.value(forKey: "url") as? String
        self.title = dic.value(forKey: "title") as? String
        let views =  dic.value(forKey: "view") as? [String]
        if views != nil && (views?.count)! >= 0{
            self.view = (NumberFormatter().number(from:(views?[0])!)?.int16Value)!
        }
        self.date = CommonUtil.convertToDate(dateString: dic.value(forKey: "date") as! String) as NSDate?
        
        let catArr = dic.value(forKey: "cat") as! [String]
        for value in catArr{
            let cat = CategoryDao.getCategory(name: value)
            cat?.addToEntries(self)
            self.addToCategories(cat!)
        }
    }
}
