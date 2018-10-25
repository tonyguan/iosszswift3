//
//  MyDatePickerViewController.swift
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

public protocol MyDatePickerViewControllerDelegate {
    func myPickDateViewControllerDidFinish(controller : MyDatePickerViewController, andSelectedDate selected : NSDate)
}


public class MyDatePickerViewController: UIViewController {

    @IBOutlet weak var datePickerView: UIDatePicker!
    
    public var delegate:MyDatePickerViewControllerDelegate?
    
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public init(){
        let resourcesBundle = NSBundle(forClass:MyDatePickerViewController.self)
        super.init(nibName: "MyDatePickerViewController", bundle: resourcesBundle)
    }
  
    override public func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        self.delegate?.myPickDateViewControllerDidFinish(self, andSelectedDate: self.datePickerView.date)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.hideInView()
    }
    

}
