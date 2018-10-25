//
//  RootViewController.swift
//  HelloiOS
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

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.whiteColor()
        
        let screen = UIScreen.mainScreen().bounds;
        let labelWidth:CGFloat = 68
        let labelHeight:CGFloat = 20
        let labelTopView:CGFloat = 200
        var label = UILabel(frame: CGRectMake((screen.size.width - labelWidth)/2 , labelTopView, labelWidth, labelHeight))
        
        label.text = "HelloiOS"
        self.view.addSubview(label)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
