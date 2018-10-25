//
//  ViewController.swift
//  DeleteAddCell
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

class ViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var txtField: UITextField!
    
    var listTeams : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置导航栏
        self.navigationItem.rightBarButtonItem =  self.editButtonItem()
        self.navigationItem.title = "单元格插入和删除"
        
        //设置单元格文本框
        self.txtField.hidden = true
        self.txtField.delegate = self
        
        self.listTeams = NSMutableArray(array: ["黑龙江", "吉林", "辽宁"])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //UIViewController生命周期方法，用于响应视图编辑状态变化
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        self.tableView.setEditing(editing, animated: true)
        if editing {
            self.txtField.hidden = false
        } else {
            self.txtField.hidden = true
        }
    }

    //实现数据源方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listTeams.count + 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CellIdentifier"
        
        var b_addCell = (indexPath.row == self.listTeams.count)
        
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier:cellIdentifier)
        }
        
        if (b_addCell == false) {
            cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell.textLabel?.text = self.listTeams[indexPath.row] as? String
        } else {
            self.txtField.frame = CGRectMake(10,5,300,44)
            self.txtField.borderStyle = UITextBorderStyle.None
            self.txtField.placeholder = "Add..."
            self.txtField.text = ""
            cell.contentView.addSubview(self.txtField)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        if (indexPath.row == self.listTeams.count) {
            return UITableViewCellEditingStyle.Insert
        } else {
            return UITableViewCellEditingStyle.Delete
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var indexPaths = [indexPath]
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            self.listTeams.removeObjectAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        } else if (editingStyle == UITableViewCellEditingStyle.Insert) {
            self.listTeams.insertObject(self.txtField.text , atIndex: self.listTeams.count)
            self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Fade)
        }
        self.tableView.reloadData()
    
    
    
    
    
    
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if (indexPath.row == self.listTeams.count) {
            return false
        } else {
            return true
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
}

