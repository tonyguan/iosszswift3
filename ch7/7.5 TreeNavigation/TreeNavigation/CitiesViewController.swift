//
//  CitiesViewController.swift
//  TreeNavigation
//
//  Created by 关东升 on 2015-5-18.
//  本书网站：http://www.51work6.com
//  智捷课堂在线课堂：http://www.zhijieketang.com/
//  智捷课堂微信公共号：zhijieketang
//  作者微博：@tony_关东升
//  QQ：569418560 邮箱：eorient@sina.com
//  QQ交流群：162030268
//

import UIKit

class CitiesViewController: UITableViewController {

    var listData: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - 实现表视图数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CellIdentifier"
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? UITableViewCell
        
        let row = indexPath.row
        let dict = self.listData[row] as! NSDictionary
        
        cell.textLabel?.text = dict["name"] as? String
        
        return cell
    }
    
    //选择表视图行时触发
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "ShowSelectedCity") {
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            let indexPath = self.tableView.indexPathForSelectedRow() as NSIndexPath?
            let selectedIndex = indexPath!.row
            
            let dict = self.listData[selectedIndex] as! NSDictionary
            
            detailViewController.url = dict["url"] as! String
            detailViewController.title = dict["name"] as? String
            
        }
        
    }
}
