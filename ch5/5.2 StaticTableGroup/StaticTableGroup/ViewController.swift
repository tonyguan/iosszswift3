//
//  ViewController.swift
//  StaticTableGroup
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

    @IBOutlet weak var txtUserName: UITextField!
    
    @IBOutlet weak var txtPwd: UITextField!
    
    @IBAction func login(sender: AnyObject) {
        if (self.txtPwd.text == "123") && (self.txtUserName.text == "tony") {
            NSLog("登录成功。")
            self.txtPwd.resignFirstResponder()
            self.txtUserName.resignFirstResponder()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

