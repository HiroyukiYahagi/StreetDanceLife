//
//  Constants.swift
//  StreetDanceLife
//
//  Created by Hiroyuki Yahagi on 2016/10/02.
//  Copyright © 2016年 Hiroyuki Yahagi. All rights reserved.
//

import UIKit

public class Constants {
    
}

enum RankingMode {
    case all
    case weekly
    case monthly
    case threeMonthly
    case favorite
    
    func getName() -> String{
        switch self.hashValue {
        case RankingMode.all.hashValue:
            return "All"
        case RankingMode.weekly.hashValue:
            return "Weekly"
        case RankingMode.monthly.hashValue:
            return "Monthly"
        case RankingMode.threeMonthly.hashValue:
            return "3 Monthly"
        default:
            return ""
        }
    }
    
    func getNumber() -> Int?{
        switch self.hashValue {
        case RankingMode.all.hashValue:
            return nil
        case RankingMode.weekly.hashValue:
            return 7
        case RankingMode.monthly.hashValue:
            return 30
        case RankingMode.threeMonthly.hashValue:
            return 90
        default:
            return nil
        }
    }
}

enum FixedMenu{
    case favorite
    case setting
    
    func getImage() -> UIImage? {
        switch self {
        case FixedMenu.favorite:
            return UIImage(named: "ic_star.png")
        case FixedMenu.setting:
            return UIImage(named: "ic_setting.png")
//        default:
//            return nil
        }
    }
    
    func getTitle() -> String{
        switch self {
        case FixedMenu.favorite:
            return "Favorite"
        case FixedMenu.setting:
            return "Setting"
//        default:
//            return ""
        }
    }
    
    func getViewController() -> UIViewController?{
        switch self {
        case FixedMenu.favorite:
            return nil
        case FixedMenu.setting:
            return  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SettingViewController")
//        default:
//            return nil
        }
    }
}
