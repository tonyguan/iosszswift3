//
//  ViewController.swift
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

class ViewController: UITableViewController {

    var dictData: NSDictionary!
    var listData: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let plistPath = NSBundle.mainBundle().pathForResource("provinces_cities", ofType: "plist")

        self.dictData = NSDictionary(contentsOfFile: plistPath!)
        self.listData = self.dictData.allKeys as NSArray
        self.title = "省份信息"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITableViewDataSource 协议方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listData.count
    }
    //实现表视图数据源方法
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CellIdentifier"

        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? UITableViewCell
        
        let row = indexPath.row
        cell.textLabel?.text = self.listData[row] as? String
        
        return cell
    }

    //选择表视图行时触发
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "ShowSelectedProvince") {
            let citiesViewController = segue.destinationViewController as! CitiesViewController
            let indexPath = self.tableView.indexPathForSelectedRow() as NSIndexPath?
            let selectedIndex = indexPath!.row
            
            let selectName = self.listData[selectedIndex] as! String
            citiesViewController.listData = self.dictData[selectName] as! NSArray
            citiesViewController.title = selectName

        }
            
    }

}

