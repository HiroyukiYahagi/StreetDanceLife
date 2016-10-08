//
//  CommonUtil.swift
//  StreetDanceLife
//
//  Created by Hiroyuki Yahagi on 2016/10/02.
//  Copyright © 2016年 Hiroyuki Yahagi. All rights reserved.
//

import UIKit

class CommonUtil {
    
    
    fileprivate static var dateFormatterJP:DateFormatter?
    
    static func getContentsFromUrl(_ url:String?, complete:@escaping (Data?, URLResponse?, Error?)->Void? ){
        if(url == nil){
            return
        }
        let urlObj:URL? = URL(string: url!)
        if(urlObj == nil){
            return
        }
        let task = URLSession.shared.dataTask(with: urlObj!) { (data:Data?, urlResponse:URLResponse?, error:Error?) in
            complete(data, urlResponse, error)
        }
        task.resume()
    }
    
//    static func parse(_ urlString: String, callback:([NSDictionary]?)->Void? ) {
//        let url = URL(string: urlString)!
//        let myRequest:URLRequest  = URLRequest(url: url)
//        let data:Data = try! NSURLConnection.sendSynchronousRequest(myRequest, returning: nil)
//        let dict = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [NSDictionary]
//        if(dict != nil){
//            callback(dict!)
//        }
//    }
    
    static func asyncParse(_ urlString: String, callback:@escaping ([NSDictionary]?, _ error:Error? )->Void? ) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: {data, response, error in
            
            if(error != nil){
                callback(nil, error)
                return
            }
            // conver json to dictionary
            let dics = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [NSDictionary]
            callback(dics, nil)
        })
        task.resume()
    }
    
    static func getDateFormatterJP() -> DateFormatter{
        if(CommonUtil.dateFormatterJP == nil){
            CommonUtil.dateFormatterJP = DateFormatter()
            CommonUtil.dateFormatterJP?.locale = Locale(identifier: "ja_JP")
            CommonUtil.dateFormatterJP?.dateFormat = "yyyy-MM-dd HH:mm:ss"
        }
        return CommonUtil.dateFormatterJP!
    }
    
    static func convertToDate(dateString:String) -> NSDate?{
        return CommonUtil.getDateFormatterJP().date(from: dateString) as NSDate?
    }
}

