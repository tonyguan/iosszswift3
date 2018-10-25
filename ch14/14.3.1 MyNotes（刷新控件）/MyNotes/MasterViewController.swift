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

enum ActionTypes {
    case QUERY      //查询操作
    case REMOVE     //删除操作
    case ADD        //添加操作
    case MOD        //修改操作
}

class MasterViewController: UITableViewController, NSURLConnectionDataDelegate {
    
    //请求动作标识
    var action = ActionTypes.QUERY
    //删除行号
    var deleteRowId = -1
    
    //保存数据列表
    var objects = NSMutableArray()
    //接收从服务器返回数据。
    var datas : NSMutableData!
    
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
        
        //查询请求数据
        action = ActionTypes.QUERY
        self.startRequest()
        
        //初始化UIRefreshControl
        var rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: "refreshTableView", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc
    }
    
    func refreshTableView() {
        
        if (self.refreshControl?.refreshing == true) {
            self.refreshControl?.attributedTitle = NSAttributedString(string: "加载中...")
            //查询请求数据
            action = ActionTypes.QUERY
            self.startRequest()
        }
    }
    
    //    override func viewWillAppear(animated: Bool) {
    //        super.viewWillAppear(true)
    //        action = ActionTypes.QUERY
    //        self.startRequest()
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                
                let dict:NSDictionary = objects[indexPath.row] as! NSDictionary
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                //传递数据给详细视图控制器
                controller.detailItem = dict
            }
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
            //删除数据
            action = ActionTypes.REMOVE
            deleteRowId = indexPath.row
            self.startRequest()
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // MARK: --开始请求Web Service
    func startRequest()
    {
        
        let strURL = "http://www.51work6.com/service/mynotes/WebService.php"
        var post = ""
        if action == ActionTypes.QUERY {//查询处理
            post = String(format: "email=%@&type=%@&action=%@", "<你的51work6.com用户邮箱>", "JSON", "query")
        } else if action == ActionTypes.REMOVE {//删除处理
            let dict = self.objects[deleteRowId] as! NSMutableDictionary
            let id = dict.objectForKey("ID") as! NSNumber
            post = String(format: "email=%@&type=%@&action=%@&id=%@", "<你的51work6.com用户邮箱>", "JSON", "remove",id)
        }
        let postData: NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let url = NSURL(string: strURL)!
        
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        var connection  = NSURLConnection(request: request, delegate: self)
        
        if connection != nil {
            self.datas = NSMutableData()
        }
        
    }
    
    // MARK: --NSURLConnection 回调方法
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.datas.appendData(data)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        NSLog("%@",error.localizedDescription)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        NSLog("请求完成...")
        
        var resDict = NSJSONSerialization.JSONObjectWithData(self.datas, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary!
        
        if action == ActionTypes.QUERY {//查询处理
            if resDict != nil {
                self.reloadView(resDict)
            }
        } else if action == ActionTypes.REMOVE {//删除处理
            
            var message = "操作成功。"
            
            let resultCode = resDict.objectForKey("ResultCode") as! NSNumber
            
            if (resultCode.integerValue < 0) {
                message = resultCode.errorMessage
            }
            
            let alertView = UIAlertView(title: "提示信息", message: message,
                delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            
            //重新查询
            action = ActionTypes.QUERY
            self.startRequest()
        }
    }
    
    // MARK: --处理通知
    func reloadView(res : NSDictionary) {        
        
        self.refreshControl?.endRefreshing()
        self.refreshControl?.attributedTitle = NSAttributedString(string: "下拉刷新")
        
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

