//
//  ViewController.swift
//  SimpleTable
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

class ViewController: UITableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    var listTeams : NSArray!
    var listFilterTeams : NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //设置搜索栏委托对象为当前视图控制器
        self.searchBar.delegate = self
        //设置搜索范围栏隐藏
        self.searchBar.showsScopeBar = false
        self.searchBar.sizeToFit()
        
        let plistPath = NSBundle.mainBundle().pathForResource("team", ofType: "plist")
        //获取属性列表文件中的全部数据
        self.listTeams = NSArray(contentsOfFile: plistPath!)
        
        //初次进入查询所有数据
        self.filterContentForSearchText("", scope:-1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //过滤结果集方法
    func filterContentForSearchText(searchText: NSString, scope: Int) {
        if(searchText.length == 0) {
            //查询所有
            self.listFilterTeams = NSMutableArray(array:self.listTeams)
            return
        }
        var tempArray : NSArray!
        
        if (scope == 0) {         //英文 image字段保存英文名
           let scopePredicate = NSPredicate(format:"SELF.image contains[c] %@", searchText)
            tempArray = self.listTeams.filteredArrayUsingPredicate(scopePredicate)
            self.listFilterTeams = NSMutableArray(array: tempArray)
        } else if (scope == 1) { //中文 name字段是中文名
            let scopePredicate = NSPredicate(format:"SELF.name contains[c] %@", searchText)
            tempArray = self.listTeams.filteredArrayUsingPredicate(scopePredicate)
            self.listFilterTeams = NSMutableArray(array: tempArray)
        } else {                //查询所有
            self.listFilterTeams = NSMutableArray(array: self.listTeams)
        }
    }
    
    //UITableViewDataSource 协议方法
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listFilterTeams.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CellIdentifier"
        
        var cell:UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath:indexPath) as? UITableViewCell
        
        let row = indexPath.row
        let rowDict = self.listFilterTeams[row] as! NSDictionary
        
        cell.textLabel?.text = rowDict["name"] as? String
        let imagePath = String(format: "%@.png", rowDict["image"] as! String)
        cell.imageView?.image = UIImage(named: imagePath)
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    /// 实现 UISearchBarDelegate 协议方法
    //  获得焦点，成为第一响应者
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.showsScopeBar = true
        self.searchBar.sizeToFit()
        return true
    }
    
    //点击键盘上的搜索按钮
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchBar.showsScopeBar = false
        self.searchBar.resignFirstResponder()
        self.searchBar.sizeToFit()
    }
    //点击搜索栏取消按钮
    func searchBarCancelButtonClicked(searchBar : UISearchBar) {
        //查询所有
        self.filterContentForSearchText("", scope:-1)
        self.searchBar.showsScopeBar = false
        self.searchBar.resignFirstResponder()
        self.searchBar.sizeToFit()
    }
    
    //当文本内容发生改变时候调用
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterContentForSearchText(searchText, scope:self.searchBar.selectedScopeButtonIndex)
        self.tableView.reloadData()
    }
    
    //当搜索范围选择发生变化时候调用
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterContentForSearchText(self.searchBar.text, scope:selectedScope)
        self.tableView.reloadData()
    }

}



