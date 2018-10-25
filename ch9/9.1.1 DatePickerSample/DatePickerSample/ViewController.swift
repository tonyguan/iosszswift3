//
//  ViewController.swift
//  DatePickerSample
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

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var label: UILabel!
    
    @IBAction func onclick(sender: AnyObject) {
        
        var theDate : NSDate = self.datePicker.date
        let desc = theDate.descriptionWithLocale(NSLocale.currentLocale())!
        NSLog("the date picked is: %@", desc)
        
        var dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        NSLog("the date formate is: %@", dateFormatter.stringFromDate(theDate))
        
        self.label.text = dateFormatter.stringFromDate(theDate)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

