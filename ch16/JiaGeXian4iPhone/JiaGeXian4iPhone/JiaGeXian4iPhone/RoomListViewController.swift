//
//  RoomListViewController.swift
//  JiaGeXian4iPhone
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

class RoomListViewController: UITableViewController {

    //查询结果
    var list = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "房间列表"
        
        let backgroundView = UIImageView(image: UIImage(named: "BackgroundSearch"))
        backgroundView.frame = self.tableView.frame
        self.tableView.backgroundView = backgroundView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! RoomTableViewCell
        
        let dict = self.list[indexPath.row] as! [String : String]
        
        cell.lblName.text = dict["name"]
        cell.lblBreakfast.text = dict["breakfast"]
        cell.lblBroadband.text = dict["broadband"]
        cell.lblFrontprice.text = dict["frontprice"]
        cell.lblPaymode.text = dict["paymode"]

        return cell
    }
 
}
