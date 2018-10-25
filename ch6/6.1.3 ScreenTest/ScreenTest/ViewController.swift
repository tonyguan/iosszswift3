//
//  ViewController.swift
//  ScreenTest
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

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let iOSDeviceScreenSize : CGSize = UIScreen.mainScreen().bounds.size
        NSLog("%@ x %@", iOSDeviceScreenSize.width, iOSDeviceScreenSize.height)
        var s = String(format: "%@ x %@", iOSDeviceScreenSize.width, iOSDeviceScreenSize.height)
        self.label.text = s
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) {
            
            if (iOSDeviceScreenSize.height > iOSDeviceScreenSize.width) {//竖屏情况
                if (iOSDeviceScreenSize.height == 568) {//iPhone 5/5s/5c（iPod touch 5）设备
                    NSLog("iPhone 5/5s/5c（iPod touch 5）设备")
                } else if (iOSDeviceScreenSize.height == 667) {//iPhone 6
                    NSLog("iPhone 6 设备")
                } else if (iOSDeviceScreenSize.height == 736) {//iPhone 6 plus
                    NSLog("iPhone 6 plus 设备")
                } else {//iPhone4s等其它设备
                    NSLog("iPhone4s等其它设备")
                }
            }
            if (iOSDeviceScreenSize.width > iOSDeviceScreenSize.height) {//横屏情况
                if (iOSDeviceScreenSize.width == 568) {//iPhone 5/5s/5c（iPod touch 5）设备
                    NSLog("iPhone 5/5s/5c（iPod touch 5）设备")
                } else if (iOSDeviceScreenSize.width == 667) {//iPhone 6
                    NSLog("iPhone 6 设备")
                } else if (iOSDeviceScreenSize.width == 736) {//iPhone 6 plus
                    NSLog("iPhone 6 plus 设备")
                } else {//iPhone4s等其它设备
                    NSLog("iPhone4s等其它设备")
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

