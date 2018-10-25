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

class MasterViewController: UITableViewController , NoteBLDelegate {
    
    //业务逻辑对象BL
    var bl = NoteBL()
    //保存数据列表
    var objects = NSMutableArray()
    //删除数据索引
    var deletedIndex: Int!
    //删除数据
    var deletedNote: Note!
    
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
        
        self.bl.delegate = self
        
        //初始化UIRefreshControl
        var rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        rc.addTarget(self, action: "refreshTableView", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl = rc
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //查询所有的数据
        self.bl.findAllNotes()
    }
    
    func refreshTableView() {
        
        if (self.refreshControl!.refreshing == true) {
            self.refreshControl!.attributedTitle = NSAttributedString(string: "加载中...")
            //查询所有的数据
            self.bl.findAllNotes()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                
                let object = objects[indexPath.row] as! Note
                
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                //传递数据给详细视图控制器
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
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
        
        let object = objects[indexPath.row] as! Note
        cell.textLabel?.text = object.content
        cell.detailTextLabel?.text = object.date
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if editingStyle == .Delete {
            
            self.deletedIndex = indexPath.row
            self.deletedNote = objects[indexPath.row] as! Note
            
            self.bl.removeNote(self.deletedNote)
            
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    // MARK:- 处理通知
    //查询所有数据方法 成功
    func findAllNotesFinished(list : NSMutableArray) {
        self.objects  = list
        self.tableView.reloadData()
        if self.refreshControl != nil {
            self.refreshControl!.endRefreshing()
            self.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新")
        }
    }
    
    //查询所有数据方法 失败
    func findAllNotesFailed(error : NSError) {
        
        let errorStr = error.localizedDescription
        
        let alertView = UIAlertView(title: "操作信息",
            message: errorStr,
            delegate: nil,
            cancelButtonTitle: "OK")
        alertView.show()
        
        if self.refreshControl != nil {
            self.refreshControl!.endRefreshing()
            self.refreshControl!.attributedTitle = NSAttributedString(string: "下拉刷新")
        }
    }
    
    
    //删除Note方法 成功
    func removeNoteFinished() {
        let alertView = UIAlertView(title: "操作信息",
            message: "删除成功。",
            delegate: nil,
            cancelButtonTitle: "OK")
        
        alertView.show()
        
        self.objects.removeObjectAtIndex(self.deletedIndex)
        self.tableView.reloadData()
    }
    
    //删除Note方法 失败
    func removeNoteFailed(error : NSError) {
        let errorStr = error.localizedDescription
        
        let alertView = UIAlertView(title: "操作信息",
            message: errorStr,
            delegate: nil,
            cancelButtonTitle: "OK")
        alertView.show()
    }
    
    //修改Note方法 成功
    func modifyNoteFinished() {}
    
    //修改Note方法 失败
    func modifyNoteFailed(error : NSError) {}
    
    //插入Note方法 成功
    func createNoteFinished(){}
    
    //插入Note方法 失败
    func createNoteFailed(error : NSError){}
}

