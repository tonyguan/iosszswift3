//
//  ViewController.swift
//  CustomCell
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

    var listTeams : NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let plistPath = NSBundle.mainBundle().pathForResource("team", ofType: "plist")
        //获取属性列表文件中的全部数据
        self.listTeams = NSArray(contentsOfFile: plistPath!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITableViewDataSource 协议方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listTeams.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CellIdentifier"
        
        var cell:CustomCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? CustomCell

        let row = indexPath.row
        let rowDict = self.listTeams[row] as! NSDictionary
        
        cell.myLabel.text = rowDict["name"] as? String
        
        let imageFile = rowDict["image"] as! String
        let imagePath = String(format: "%@.png", imageFile)
        cell.myImageView.image = UIImage(named: imagePath)
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
}

