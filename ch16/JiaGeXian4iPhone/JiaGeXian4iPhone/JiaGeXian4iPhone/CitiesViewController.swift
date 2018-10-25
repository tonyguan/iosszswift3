//
//  CitiesViewController.swift
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

protocol CitiesViewControllerDelegate {
    func closeCitiesView(info : [String : String])
}

class CitiesViewController: UITableViewController {

    //所有城市信息列表
    var cities : [AnyObject]!
    
    var delegate: CitiesViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cityPlistPath = NSBundle.mainBundle().pathForResource("cities", ofType: "plist")
        
        //按照拼写排序
        let bySpell = NSSortDescriptor(key: "spell" , ascending: true)
        self.cities = NSArray(contentsOfFile: cityPlistPath!)?.sortedArrayUsingDescriptors([bySpell])
        
        let backgroundView = UIImageView(image: UIImage(named: "BackgroundSearch"))
        backgroundView.frame = self.tableView.frame
        self.tableView.backgroundView = backgroundView
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor(red: 48.0/255, green: 89.0/255, blue: 181.0/255, alpha: 1.0)
        navigationBar?.tintColor = UIColor(red: 112.0/255, green: 180.0/255, blue: 255.0/255, alpha: 1.0)
        
        let navbarTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        navigationBar?.titleTextAttributes = navbarTitleTextAttributes
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let dict = self.cities[indexPath.row] as! [String : String]
        
        cell.textLabel?.text = dict["name"]
        cell.detailTextLabel?.text = dict["spell"]
        
        return cell
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let dict = self.cities[indexPath.row] as! [String : String]
        self.delegate?.closeCitiesView(dict)
    }
}
