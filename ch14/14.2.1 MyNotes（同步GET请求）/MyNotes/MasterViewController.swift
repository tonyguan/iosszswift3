//
//  MasterViewController.swift
//  MyNotes
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

class MasterViewController: UITableViewController {
    
    //保存数据列表
    var objects = NSMutableArray()
    
    var detailViewController: DetailViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        
        self.startRequest()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            //            if let indexPath = self.tableView.indexPathForSelectedRow() {
            //
            //                let object = objects[indexPath.row] as Note
            //
            //                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
            //                //传递数据给详细视图控制器
            //                controller.detailItem = object
            //            }
        }
    }
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let dict = self.objects[indexPath.row] as! NSDictionary
        
        cell.textLabel?.text = dict["Content"] as? String
        cell.detailTextLabel?.text = dict["CDate"] as? String
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            //objects.removeObjectAtIndex(indexPath.row)
            //            let object = objects[indexPath.row] as Note
            //            self.objects = bl.remove(object)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    //开始请求Web Service
    func startRequest()
    {
        
        var strURL = String(format: "http://www.51work6.com/service/mynotes/WebService.php?email=%@&type=%@&action=%@", "<你的51work6.com用户邮箱>", "JSON", "query")
        strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        let url = NSURL(string: strURL)!
        
        var request = NSURLRequest(URL: url)
        
        var error: NSError?
        
        var data  = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: &error)!
        
        if error != nil {
            NSLog("请求失败")
        } else {
            
            //let resstr = NSString(data: data, encoding: NSUTF8StringEncoding)
            
            var resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary!
            
            if resDict != nil {
                self.reloadView(resDict)
            }
        }
        NSLog("请求完成...")
        
    }
    
    
    // MARK: --处理通知
    func reloadView(res : NSDictionary) {
        
        let resultCode: NSNumber = res.objectForKey("ResultCode") as! NSNumber
        
        if (resultCode.integerValue >= 0) { //成功
            
            self.objects = res.objectForKey("Record") as! NSMutableArray
            self.tableView.reloadData()
            
        } else {
            
            let errorStr = resultCode.errorMessage
            
            let alertView = UIAlertView(title: "错误信息", message: errorStr,
                delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
    }
}

