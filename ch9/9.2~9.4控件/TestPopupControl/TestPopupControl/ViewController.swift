//
//  ViewController.swift
//  TestPopupControl
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
import PopupControl

class ViewController: UIViewController , MyPickerViewControllerDelegate,  MyDatePickerViewControllerDelegate {
    
    var pickerViewController = MyPickerViewController()
    var datePickerViewController = MyDatePickerViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerViewController.delegate = self
        self.datePickerViewController.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //测试MyPickerViewController
    @IBAction func test1(sender: AnyObject) {
        self.pickerViewController.showInView(self.view)
    }
    
    //测试MyDatePickerViewController
    @IBAction func test2(sender: AnyObject) {
        self.datePickerViewController.showInView(self.view)
    }
    
    //实现委托MyPickerViewControllerDelegate协议
    func myPickViewClose(selected : String) {
        NSLog("selected %@",selected)
    }
    
    //实现委托MyDatePickerViewControllerDelegate协议
    func myPickDateViewControllerDidFinish(controller : MyDatePickerViewController, andSelectedDate selected : NSDate) {
        NSLog("selected %@",selected)
        
    }
    
}
