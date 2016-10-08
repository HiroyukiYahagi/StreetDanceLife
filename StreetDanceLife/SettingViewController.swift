//
//  SettingViewController.swift
//  StreetDanceLife
//
//  Created by Hiroyuki Yahagi on 2016/10/02.
//  Copyright © 2016年 Hiroyuki Yahagi. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let settingMenu:[(String, String, String)] = [
        ("Default Genre", "Select your genre", ""),
        ("Share this app", "Please share this app to dancers all over the world", ""),
        ("Official Facebook", "Please Like", "https://www.facebook.com/lifestreetdance/"),
        ("Official Twitter", "Please share", "https://twitter.com/street_dance_"),
        ("Site Top", "http://streetdance.life/", "http://streetdance.life/")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            let vc = storyboard?.instantiateViewController(withIdentifier: "DefaultCategoryTableViewController") as! DefaultCategoryTableViewController
            self.present(vc, animated: true, completion: nil)
            return
        case 1:
            let (_, _, urlStr) = settingMenu[indexPath.row + indexPath.section*1]
            let url = NSURL(string: urlStr)
            UIApplication.shared.openURL(url as! URL)
            return
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 4
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Setting"
        case 1:
            return "Other"
        default:
            return ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let (title, subtitle, _) = settingMenu[indexPath.row + indexPath.section * 1]
        
        for view in cell.subviews[0].subviews {
            switch view.tag {
            case 0:
                let label = view as! UILabel
                label.text = title
                break
            case 1:
                let label = view as! UILabel
                label.text = subtitle
                break
            default:
                break
            }
        }
        return cell
    }
}
