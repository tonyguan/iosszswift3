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


    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        //查询所有的数据
        //self.objects = self.bl.findAll()
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "reloadView:",
            name: "reloadViewNotification", object: nil)
        
        var parser =  NotesXMLParser()//NotesTBXMLParser()
        parser.start()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSNotificationCenter.defaultCenter().removeObserver(self)
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

    // MARK: --处理通知
    func reloadView(notification : NSNotification) {
        var resList = notification.object as! NSMutableArray
        self.objects  = resList
        self.tableView.reloadData()
    }

}

