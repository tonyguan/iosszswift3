//
//  HotelListViewController.swift
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

class HotelListViewController: UITableViewController {
    
    //当前页数
    var currentPage = 1
    //查询条件
    var queryKey: [String : AnyObject]!
    //查询结果
    var list = [AnyObject]()

    //查询房间条件
    var queryRoomKey: [String : AnyObject]!
    //查询房间结果
    var roomList: [AnyObject]!
    
    @IBOutlet weak var loadViewCell: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "酒店列表"
        
        let backgroundView = UIImageView(image: UIImage(named: "BackgroundSearch"))
        backgroundView.frame = self.tableView.frame
        self.tableView.backgroundView = backgroundView
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "queryHotelFinished:", name: BLQueryHotelFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "queryHotelFailed:", name: BLQueryHotelFailedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "queryRoomFinished:", name: BLQueryRoomFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "queryRoomFailed:", name: BLQueryRoomFailedNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! HotelTableViewCell

        let dict = self.list[indexPath.row] as! [String : String]
        
        cell.lblName.text = dict["name"]
        cell.lblAddress.text = dict["address"]
        cell.lblPrice.text = dict["lowprice"]
        cell.lblGrade.text = dict["grade"]
        cell.lblPhone.text = dict["phone"]
        
        let htmlPath = NSBundle.mainBundle().pathForResource("myIndex", ofType: "html")
        let bundleUrl = NSURL(fileURLWithPath: NSBundle.mainBundle().bundlePath)
        var html = NSMutableString(contentsOfFile: htmlPath!, encoding: NSUTF8StringEncoding, error: nil)
        
        let subRange = html?.rangeOfString("####")
        if subRange?.location != NSNotFound {
            html?.replaceCharactersInRange(subRange!, withString: dict["img"]!)
        }
        cell.webView.loadHTMLString(html as String!, baseURL: bundleUrl!)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (self.list.count == indexPath.row + 1) && self.loadViewCell.hidden == false {
            NSLog("load data...")
            currentPage++
            let currentPageStr = NSString(format: "%i", currentPage)
            self.queryKey["currentPage"] = currentPageStr
            HotelBL.sharedInstance.queryHotel(self.queryKey)
            
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if identifier == "showRoomDetail" {
            var qkey = [String : AnyObject]()
            qkey["Checkin"] = self.queryKey["Checkin"]
            qkey["Checkout"] = self.queryKey["Checkout"]
            
            let indexPath = self.tableView.indexPathForSelectedRow()
            let dict: AnyObject = self.list[indexPath!.row]
            qkey["hotelId"] = dict["id"]
            
            self.queryRoomKey = qkey
            
            RoomBL.sharedInstance.queryRoom(self.queryRoomKey)
            
            return false
        }
        return true
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showRoomDetail" {
            let roomListViewController = segue.destinationViewController as! RoomListViewController
            roomListViewController.list = self.roomList
        }
    }
    
    
    //接收BL查询Hotel信息成功通知
    func queryHotelFinished(not : NSNotification) {
        
        let resList = not.object as! [AnyObject]
        
        if resList.count < 20 {
            self.loadViewCell.hidden = true
        } else {
            self.loadViewCell.hidden = false
        }
        
        if currentPage == 1 {
            self.list = [AnyObject]()
        }
        
        self.list += resList //.append(resList)
        self.tableView.reloadData()
    }
    
    //接收BL查询Hotel信息失败通知
    func queryHotelFailed(not : NSNotification) {
        
        let error = not.object as! NSError
        let errorStr = error.localizedDescription
        let alertView = UIAlertView(title: "出错信息", message:errorStr, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
        
    }
    
    //接收BL查询房间成功通知
    func queryRoomFinished(not : NSNotification) {
        
        self.roomList = not.object  as! [AnyObject]
        
        if self.roomList.count == 0 {
            let alertView = UIAlertView(title: "出错信息", message:"没有房间数据", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        } else {
            self.performSegueWithIdentifier("showRoomDetail", sender: nil)
        }
    }
    
    //接收BL查询房间失败通知
    func queryRoomFailed(not : NSNotification) {
        
        let error = not.object as! NSError
        let errorStr = error.localizedDescription
        let alertView = UIAlertView(title: "出错信息", message:errorStr, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
        
    }
    
}
