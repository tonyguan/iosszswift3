//
//  MyPickerViewController.swift
//  PopupControl
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

public protocol MyPickerViewControllerDelegate {
    func myPickViewClose(selected : String)
}

public class MyPickerViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    var pickerData : NSArray!

    public var delegate:MyPickerViewControllerDelegate?
    
    @IBOutlet weak var picker: UIPickerView!
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(){
        let resourcesBundle = NSBundle(forClass:MyPickerViewController.self)
        super.init(nibName: "MyPickerViewController", bundle: resourcesBundle)
        
        self.pickerData = ["价格不限", "￥0-->￥1000 元/天", "￥1000-->￥2000 元/天", "￥2000-->￥3000 元/天", "￥3000-->￥5000 元/天"]
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func showInView(superview : UIView) {
        
        if self.view.superview == nil {
            superview.addSubview(self.view)
        }
        
        self.view.center = CGPointMake(self.view.center.x, 900)
        self.view.frame = CGRectMake(self.view.frame.origin.x , self.view.frame.origin.y , superview.frame.size.width, self.view.frame.size.height)
        
        UIView.animateWithDuration(0.3, delay: 0.3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.view.center =  CGPointMake(superview.center.x,superview.frame.size.height - self.view.frame.size.height/2)
            
        }, completion: nil)
    }


    public func hideInView() {
        UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.view.center =  CGPointMake(self.view.center.x, 900)
            
        }, completion: nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        self.hideInView()
        let selectedIndex = self.picker.selectedRowInComponent(0)
        self.delegate?.myPickViewClose(self.pickerData[selectedIndex] as! String)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.hideInView()
    }
    
    //MARK: -- 实现协议UIPickerViewDelegate方法
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return self.pickerData[row] as! String
    }

    //MARK: -- 实现协议UIPickerViewDataSource方法
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerData.count
    }
    
}
