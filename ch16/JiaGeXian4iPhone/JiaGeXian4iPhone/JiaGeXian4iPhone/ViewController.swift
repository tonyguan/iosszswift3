//
//  ViewController.swift
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
import PopupControl

class ViewController: UIViewController,
            MyPickerViewControllerDelegate, MyDatePickerViewControllerDelegate,
            CitiesViewControllerDelegate, KeyViewControllerDelegate {

    var checkinDatePickerViewController = MyDatePickerViewController()
    var checkoutDatePickerViewController = MyDatePickerViewController()
    var pickerViewController = MyPickerViewController()
    
    var cityInfo : [String : AnyObject]!
    //关键字查询结果
    var keyDict : [String : AnyObject]!
    //Hotel查询结果
    var hotelList : [AnyObject]!
    //Hotel查询条件
    var hoteQueryKey : [String : AnyObject]!
    
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var btnKey: UIButton!
    @IBOutlet weak var btnPrice: UIButton!
    @IBOutlet weak var btnCheckin: UIButton!
    @IBOutlet weak var btnCheckout: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.checkinDatePickerViewController.delegate = self
        self.checkoutDatePickerViewController.delegate = self
        self.pickerViewController.delegate = self
        
        let navigationBar = self.navigationController?.navigationBar
        navigationBar?.barTintColor = UIColor(red: 48.0/255, green: 89.0/255, blue: 181.0/255, alpha: 1.0)
        navigationBar?.tintColor = UIColor(red: 112.0/255, green: 180.0/255, blue: 255.0/255, alpha: 1.0)
        
        let navbarTitleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        navigationBar?.titleTextAttributes = navbarTitleTextAttributes
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "queryKeyFinished:", name: BLQueryKeyFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "queryKeyFailed:", name: BLQueryKeyFailedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "queryHotelFinished:", name: BLQueryHotelFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "queryHotelFailed:", name: BLQueryHotelFailedNotification, object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    

    @IBAction func selectPrice(sender: AnyObject) {
        self.pickerViewController.showInView(self.view)
    }
    
    @IBAction func selectCheckinDate(sender: AnyObject) {
        self.checkinDatePickerViewController.showInView(self.view)
    }
    
    @IBAction func selectCheckoutDate(sender: AnyObject) {
        self.checkoutDatePickerViewController.showInView(self.view)
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if identifier == "selectKey" && self.btnCity.titleLabel!.text == "选择城市" {
            let alertView = UIAlertView(title: "提示信息", message: "请先选择城市", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            return false
        } else if identifier == "selectKey" {
            HotelBL.sharedInstance.selectKey(self.btnCity.titleLabel!.text)
            return false
        } else if identifier == "queryHotel" {
            var errorMsg = ""
            
            if self.btnCity.titleLabel!.text == "选择城市" {
                errorMsg = "请选择城市"
            } else if self.btnKey.titleLabel!.text == "选择关键字" {
                errorMsg = "请选择关键字"
            } else if self.btnCheckin.titleLabel!.text == "选择日期" {
                errorMsg = "请选择入住日期"
            } else if self.btnCheckout.titleLabel!.text == "选择日期" {
                errorMsg = "请选择退房日期"
            }
            
            if errorMsg != "" {
                let alertView = UIAlertView(title: "提示信息", message: errorMsg, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                return false
            }
            
            self.hoteQueryKey = [String : String]()
            self.hoteQueryKey["Plcityid"] = self.cityInfo["Plcityid"]
            self.hoteQueryKey["currentPage"] = "1"
            self.hoteQueryKey["key"] = self.btnKey.titleLabel!.text
            self.hoteQueryKey["Price"] = self.btnPrice.titleLabel!.text
            self.hoteQueryKey["Checkin"] = self.btnCheckin.titleLabel!.text
            self.hoteQueryKey["Checkout"] = self.btnCheckout.titleLabel!.text
            
            HotelBL.sharedInstance.queryHotel(self.hoteQueryKey)
            return false
        }
        
        return true
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "selectCity" {
            let nvgViewController = segue.destinationViewController as! UINavigationController
            let citiesViewController = nvgViewController.topViewController as! CitiesViewController
            citiesViewController.delegate = self
        } else if segue.identifier == "selectKey" {
            let nvgViewController = segue.destinationViewController as! UINavigationController
            let keyViewController = nvgViewController.topViewController as! KeyViewController
            keyViewController.delegate = self
            keyViewController.keyDict = self.keyDict
        } else if segue.identifier == "queryHotel" {
            let hotelListViewController = segue.destinationViewController as! HotelListViewController
            hotelListViewController.queryKey = self.hoteQueryKey
            hotelListViewController.list = self.hotelList
        }
        
    }
    
    //关闭城市选择对话框委托方法
    func closeCitiesView(info : [String : String]) {
        self.cityInfo = info
        self.dismissViewControllerAnimated(true, completion: nil)
        self.btnCity.setTitle(info["name"], forState: UIControlState.Normal)
        self.btnKey.setTitle("选择关键字", forState: UIControlState.Normal)
    }
    
    //关闭关键字选择对话框委托方法
    func closeKeysView(selectKey : String) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.btnKey.setTitle(selectKey, forState: UIControlState.Normal)
    }
    
    //关闭价格拾取器委托方法
    func myPickViewClose(selected : String) {
        NSLog("selected %@",selected)
        self.btnPrice.setTitle(selected, forState: UIControlState.Normal)
    }
    
    //关闭日期拾取器委托方法
    func myPickDateViewControllerDidFinish(controller : MyDatePickerViewController, andSelectedDate selected : NSDate) {
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        dateFormat.locale = NSLocale(localeIdentifier: "zh_CN")
        let strDate = dateFormat.stringFromDate(selected)
        NSLog("date %@", strDate)
        
        if self.checkoutDatePickerViewController == controller {
            self.btnCheckout.setTitle(strDate, forState: UIControlState.Normal)
        } else {
            self.btnCheckin.setTitle(strDate, forState: UIControlState.Normal)
        }
    }
    
    //接收BL查询关键字成功通知
    func queryKeyFinished(not : NSNotification) {
        self.keyDict = not.object as! [String : AnyObject]
        if self.keyDict != nil {
            self.performSegueWithIdentifier("selectKey", sender: nil)
        }
    }
    
    //接收BL查询关键字失败通知
    func queryKeyFailed(not : NSNotification) {
        
        let error = not.object as! NSError
        let errorStr = error.localizedDescription
        let alertView = UIAlertView(title: "出错信息", message:errorStr, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
        
    }
    
    //接收BL查询Hotel信息成功通知
    func queryHotelFinished(not : NSNotification) {
        self.hotelList = not.object as! [AnyObject]
        
        if self.hotelList == nil || self.hotelList.count == 0 {
            let alertView = UIAlertView(title: "出错信息", message:"没有数据", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        } else {
            self.performSegueWithIdentifier("queryHotel", sender: nil)
        }
    }
    
    //接收BL查询Hotel信息成功通知
    func queryHotelFailed(not : NSNotification) {
        
        let error = not.object as! NSError
        let errorStr = error.localizedDescription
        let alertView = UIAlertView(title: "出错信息", message:errorStr, delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
        
    }
    
}

