//
//  MainViewController.swift
//  StreetDanceLife
//
//  Created by Hiroyuki Yahagi on 2016/10/02.
//  Copyright © 2016年 Hiroyuki Yahagi. All rights reserved.
//

import UIKit
import DualSlideMenu
import GoogleMobileAds

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DualSlideMenuViewControllerDelegate {

    var dualSlideMenuViewController: DualSlideMenuViewController?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var refreshIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var toolBar: UIToolbar!
    
    var shouldRefresh:Bool = true
    var readMoreIndicatorView: UIActivityIndicatorView?
    var cover:UIView?
    let rankingMenu:[RankingMode] = [RankingMode.all, RankingMode.weekly,RankingMode.monthly,RankingMode.threeMonthly]
    var entryData:[Entry]? = []
    var mode:RankingMode? = RankingMode.all
    var category:Category? = nil
    var loadedPage:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toolBar.clipsToBounds = true
        
        self.createCover()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.category = Properties.getCategory()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(category == nil){
            //初期設定画面へ遷移
            let defaultCategoryTableViewController = storyboard?.instantiateViewController(withIdentifier: "DefaultCategoryTableViewController") as! DefaultCategoryTableViewController
            self.view.window?.rootViewController?.present(defaultCategoryTableViewController, animated: true, completion: nil)
            return
        }else{
            self.refreshData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        EntityManager.save()
        super.viewDidDisappear(animated)
    }
    
    func readMoreData(){
        self.readMoreIndicatorView?.isHidden = false
        self.readMoreIndicatorView?.startAnimating()
        self.loadedPage += 1
        
        EntityManager.save()
        
        EntryDao.asyncLoadCategoriezedEntries(category: self.category!, page: self.loadedPage, rankingMode: self.mode!, completed: { (entries, err) -> Void? in
            if err != nil {
                let avc = UIAlertController(title: "通信エラー", message: "ネットワークの状況を確認し、しばらくしてから再度ご利用ください。", preferredStyle: UIAlertControllerStyle.alert)
                let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                    (action: UIAlertAction!) -> Void in
                })
                avc.addAction(defaultAction)
                self.present(avc, animated: true, completion: nil)
                return nil
            }else{
                self.entryData! += entries!
            }
        
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
                self.readMoreIndicatorView?.stopAnimating()
                self.readMoreIndicatorView?.isHidden = true
            })
            return nil
        })
    }
    
    func refreshData(){
        if(self.shouldRefresh){
            createTitleLabel()
            self.loadedPage = 0
            self.cover?.isHidden = false
            self.refreshIndicator?.isHidden = false
            self.refreshIndicator?.startAnimating()
            
            EntityManager.save()
            
            EntryDao.asyncLoadCategoriezedEntries(category: self.category!, page: self.loadedPage, rankingMode: self.mode!, completed: { (entries, err) -> Void? in
                if err != nil {
                    let avc = UIAlertController(title: "通信エラー", message: "ネットワークの状況を確認し、しばらくしてから再度ご利用ください。", preferredStyle: UIAlertControllerStyle.alert)
                    let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:{
                        (action: UIAlertAction!) -> Void in
                    })
                    avc.addAction(defaultAction)
                    self.present(avc, animated: true, completion: nil)
                }else{
                    self.entryData = entries
                    self.shouldRefresh = false
                }
                
                DispatchQueue.main.async(execute: {
                    self.tableView.setContentOffset(CGPoint.zero, animated: false)
                    self.tableView.reloadData()
                    self.cover?.isHidden = true
                    self.refreshIndicator?.isHidden = true
                    self.refreshIndicator?.stopAnimating()
                })
                return nil
            })
        }else{
            self.tableView.reloadData()
        }
    }
    
    func createTitleLabel(){
        switch self.mode!.hashValue {
        case RankingMode.all.hashValue:
            self.titleLabel.text = (self.category?.name)! + " New Video"
            break
        case RankingMode.favorite.hashValue:
            self.titleLabel.text = "Favorite Video"
            break
        default:
            self.titleLabel.text = (self.category?.name)! + " " + (self.mode?.getName())! + " Ranking"
            break
        }
    }
    
    func createCover() {
        cover = UIView()
        cover!.backgroundColor = UIColor(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.4)
        let recoganizer = UITapGestureRecognizer(target: self, action: #selector(self.touchCover))
        cover!.translatesAutoresizingMaskIntoConstraints = false
        cover!.addGestureRecognizer(recoganizer)
        self.view.addSubview(cover!)
        self.view.addConstraints([
            NSLayoutConstraint(
                item: cover!,
                attribute: NSLayoutAttribute.top,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.top,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: cover!,
                attribute: NSLayoutAttribute.bottom,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.bottom,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: cover!,
                attribute: NSLayoutAttribute.leading,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.leading,
                multiplier: 1.0,
                constant: 0
            ),
            NSLayoutConstraint(
                item: cover!,
                attribute: NSLayoutAttribute.trailing,
                relatedBy: NSLayoutRelation.equal,
                toItem: self.view,
                attribute: NSLayoutAttribute.trailing,
                multiplier: 1.0,
                constant: 0
            )
            ])
        cover!.isHidden = true
    }
    
    func touchCover(){
        dualSlideMenuViewController?.collapseAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didChangeView() {
        toggleCover()
        self.refreshData()
    }
    
    func onSwipe() {
    }
    
    @IBAction func menuButtonPressed(_ sender: AnyObject) {
        dualSlideMenuViewController!.toggle("right")
    }
    
    func toggleCover(){
        if(cover!.isHidden){
            cover!.isHidden = false
            self.view.bringSubview(toFront: cover!)
        }else{
            cover!.isHidden = true
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch self.mode!.hashValue {
            case RankingMode.favorite.hashValue:
                self.mode = RankingMode.all
                break
            default:
                self.mode = self.getListedMenu()[indexPath.row]
                break
            }
            self.shouldRefresh = true
            self.refreshData()
            return
        case 1:
            if !(isAdd(index: indexPath.row)) {
                let wvc = storyboard?.instantiateViewController(withIdentifier: "WebViewController") as! WebViewController
                wvc.entry = self.entryData?[rowForEntry(index:indexPath.row)!]
                self.view.window?.rootViewController?.present(wvc, animated: true, completion: nil)
            }
            return
        case 2:
            self.readMoreData()
            return
        default:
            return
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            switch self.mode!.hashValue {
            case RankingMode.favorite.hashValue:
                return 0
            default:
                return self.getListedMenu().count
            }
        case 1:
            return entryData!.count
        case 2:
            if(self.mode == RankingMode.all){
                return 1
            }
            return 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat? = CGFloat(0)
        switch indexPath.section {
        case 0:
            height = CGFloat(44)
            break
        case 1:
            height = CGFloat(172)
            break
        case 2:
            height = CGFloat(44)
            break
        default:
            break
        }
        return height!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "RankingCell", for: indexPath)
            let listedMenu = self.getListedMenu()[indexPath.row]
            for view in cell!.subviews[0].subviews {
                switch view.tag {
                case 0:
                    let label = view as! UILabel
                    switch listedMenu {
                    case RankingMode.all:
                        label.text = "New View >"
                        break;
                    case RankingMode.favorite:
                        label.text = ""
                        break;
                    default:
                        label.text = self.getListedMenu()[indexPath.row].getName() + " Ranking >"
                        break;
                    }
                    break
                default:
                    break
                }
            }
            break
        case 1:
            if isAdd(index: indexPath.row) {
                cell = tableView.dequeueReusableCell(withIdentifier: "AdmobCell", for: indexPath)
                for view in cell!.subviews[0].subviews {
                    switch view.tag {
                    case 0:
                        //title
                        let nativeExpressAdView = view as! GADNativeExpressAdView
                        nativeExpressAdView.adUnitID = self.nativeAdId
                        nativeExpressAdView.rootViewController = dualSlideMenuViewController
                        nativeExpressAdView.adSize = GADAdSizeFullWidthPortraitWithHeight(152)
                        let request = GADRequest()
                        nativeExpressAdView.load(request)
                        break
                    default:
                        break
                    }
                }
                break;
            }
            
            cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell", for: indexPath)
            for view in cell!.subviews[0].subviews {
                switch view.tag {
                case 1:
                    //title
                    let label = view as! UILabel
                    label.text = entryData?[rowForEntry(index:indexPath.row)!].title
                    break
                case 2:
                    //image
                    let imageView = view as! UIImageView
                    imageView.image = entryData?[rowForEntry(index:indexPath.row)!].getImageData({ (uiImage) in
                        DispatchQueue.main.async(execute: {
                            imageView.image = uiImage
                        })
                    })
                    
                    break
                case 3:
                    //catogory
                    let label = view as! UILabel
                    var labelStr:String? = ""
                    for category in (entryData?[rowForEntry(index:indexPath.row)!].categories)! {
                        labelStr = labelStr?.appending((category as! Category).name!).appending(" ")
                    }
                    label.text = labelStr
                    break
                default:
                    break
                }
            }
            break
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "NextCell", for: indexPath)
            for view in cell!.subviews[0].subviews {
                switch view.tag {
                case 1:
                    self.readMoreIndicatorView = view as? UIActivityIndicatorView
                    self.readMoreIndicatorView?.isHidden = true
                    break
                default:
                    break
                }
            }
            break
        default:
            break
        }
        
        return cell!
    }
    
    func getListedMenu() -> [RankingMode] {
        var menus:[RankingMode] = []
        for menu in self.rankingMenu {
            if menu.hashValue != self.mode?.hashValue {
                menus.append(menu)
            }
        }
        return menus
    }

    
    
    /**
     *  Ad Setting
     */

    let minimumAdRow = (Properties.getProperty(propertyName: "admob.min") as! NSNumber).intValue
    let intervalAdRow = (Properties.getProperty(propertyName: "admob.interval") as! NSNumber).intValue
    let nativeAdId = Properties.getProperty(propertyName: "admob.adId") as! String
    
    func isAdd(index:Int) -> Bool{
        if(index < minimumAdRow){
            return false
        }
        if (index - minimumAdRow) % intervalAdRow == 0 {
            return true
        }else{
            return false
        }
    }
    
    func numOfAdds(index:Int) -> Int {
        if(index < minimumAdRow){
            return 0
        }
        return (index - minimumAdRow) / intervalAdRow + 1
    }
    
    func rowForEntry(index:Int) -> Int? {
        if(isAdd(index: index)){
            return nil
        }
        return index - numOfAdds(index: index)
    }
}
