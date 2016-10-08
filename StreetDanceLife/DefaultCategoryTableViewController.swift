//
//  DefaultCategoryTableViewController.swift
//  StreetDanceLife
//
//  Created by Hiroyuki Yahagi on 2016/10/02.
//  Copyright © 2016年 Hiroyuki Yahagi. All rights reserved.
//

import UIKit

class DefaultCategoryTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var categories:[Category]? = nil
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = CategoryDao.getKeyCategories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return 1
        case 1:
            return (categories?.count)!
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell? = nil
        switch indexPath.section {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath)
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
            cell?.textLabel?.text = (categories?[indexPath.row].name)!
            break
        default:
            break
        }
        return cell!
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.section == 1){
            let _ = Properties.setCategory(category: (categories?[indexPath.row])!)
            self.dismiss(animated: true, completion: nil)
        }
    }

}
