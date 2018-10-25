//
//  KeyViewController.swift
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

protocol KeyViewControllerDelegate {
    func closeKeysView(selectKey : String)
}

class KeyViewController: UITableViewController {

    
    //关键字类型列表
    var keyTypeList : [AnyObject]!
    //关键字字典
    var keyDict : [String : AnyObject]!
    
    var delegate: KeyViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.keyTypeList = Array(self.keyDict.keys)
        
        let backgroundView = UIImageView(image: UIImage(named: "BackgroundSearch"))
        backgroundView.frame = self.tableView.frame
        self.tableView.backgroundView = backgroundView
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor(red: 48.0/255, green: 89.0/255, blue: 181.0/255, alpha: 1.0)
        navigationBar?.tintColor = UIColor(red: 112.0/255, green: 180.0/255, blue: 255.0/255, alpha: 1.0)
        
        let navbarTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        navigationBar?.titleTextAttributes = navbarTitleTextAttributes

        //设置表视图标题栏颜色
        UITableViewHeaderFooterView.appearance().tintColor = UIColor(red: 112.0/255, green: 180.0/255, blue: 255.0/255, alpha: 1.0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.keyDict.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let keyName = self.keyTypeList[section] as! String
        let keyList = self.keyDict[keyName] as! [AnyObject]
        return keyList.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let keyName = self.keyTypeList[indexPath.section] as! String
        let keyList = self.keyDict[keyName] as! [AnyObject]
        
        let dict = keyList[indexPath.row] as! [String : String]
        cell.textLabel?.text = dict["key"]
        
        return cell
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let keyName = self.keyTypeList[section] as! String
        return keyName
    }
    
    override func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return Array(self.keyDict.keys)
    }
    
    //MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let keyName = self.keyTypeList[indexPath.section] as! String
        let keyList = self.keyDict[keyName] as! [AnyObject]
        let dict = keyList[indexPath.row] as! [String : String]
        self.delegate?.closeKeysView(dict["key"]!)
    }
    
}
