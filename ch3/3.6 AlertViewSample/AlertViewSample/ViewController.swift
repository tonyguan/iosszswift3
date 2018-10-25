//
//  ViewController.swift
//  AlertViewSample
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

class ViewController: UIViewController , UIAlertViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func popupAlertView(sender: AnyObject) {
        var alertView : UIAlertView = UIAlertView(title: "Alert",
            message: "Alert text goes here",
            delegate: self,
            cancelButtonTitle: "No",
            otherButtonTitles: "Yes")
        alertView.show()
    }

    
    //实现UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        NSLog("buttonIndex = %i",buttonIndex)
    }
}

