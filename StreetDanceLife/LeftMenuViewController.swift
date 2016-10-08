//
//  LeftMenuViewController.swift
//  StreetDanceLife
//
//  Created by Hiroyuki Yahagi on 2016/10/02.
//  Copyright © 2016年 Hiroyuki Yahagi. All rights reserved.
//

import UIKit
import DualSlideMenu

class LeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dualSlideMenuViewController: DualSlideMenuViewController?

    let menus:[FixedMenu] = [FixedMenu.favorite, FixedMenu.setting]
    
    @IBOutlet weak var tableView: UITableView!
    
    var categories:[Category]? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.categories = CategoryDao.getKeyCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            let vc:UIViewController? = self.menus[indexPath.row].getViewController()
            if(vc == nil){
                let mvc = self.dualSlideMenuViewController?.mainView as! MainViewController
                mvc.mode = RankingMode.favorite
                mvc.shouldRefresh = true
                self.dualSlideMenuViewController?.collapseAll()
            }else{
                self.view.window?.rootViewController?.present(vc!, animated: true, completion: nil)
            }
            return
        case 2:
            let mvc = self.dualSlideMenuViewController?.mainView as! MainViewController
            
            if(mvc.mode == RankingMode.favorite ){
                mvc.shouldRefresh = true
            }
            
            mvc.mode = RankingMode.all
            if mvc.category != categories?[indexPath.row] {
                mvc.category = categories?[indexPath.row]
                mvc.shouldRefresh = true
            }
            self.dualSlideMenuViewController?.collapseAll()
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
            return 1
        case 1:
            return 2
        default:
            return categories!.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat? = CGFloat(0)
        switch indexPath.section {
        case 0:
            height = CGFloat(150)
            break
        case 1:
            height = CGFloat(44)
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
            cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            for view in cell!.subviews[0].subviews {
                switch view.tag {
                case 1:
                    let imageView = view as! UIImageView
                    imageView.image = UIImage(named: "icon.png")
                    break
                default:
                    break
                }
            }
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
            let menu = menus[indexPath.row]
            for view in cell!.subviews[0].subviews {
                switch view.tag {
                case 10:
                    let label = view as! UILabel
                    label.text = menu.getTitle()
                    break
                case 20:
                    let imageView = view as! UIImageView
                    imageView.image = menu.getImage()
                    break
                default:
                    break
                }
            }
            break
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
            let mvc = self.dualSlideMenuViewController?.mainView as! MainViewController
            if(mvc.category == categories?[indexPath.row]){
                cell?.subviews[0].backgroundColor = UIColor.lightGray
            }
            for view in cell!.subviews[0].subviews {
                switch view.tag {
                case 10:
                    let label = view as! UILabel
                    label.text = categories?[indexPath.row].name
                    break
                case 20:
                    let imageView = view as! UIImageView
                    if categories?[indexPath.row] ==  (Properties.getCategory()) {
                        imageView.image = UIImage(named: "ic_profile_favorite.png")
                    }else{
                        imageView.image = UIImage(named: "ic_profile.png")
                    }
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

}
