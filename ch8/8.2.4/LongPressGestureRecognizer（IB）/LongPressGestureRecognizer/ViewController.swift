//
//  ViewController.swift
//  LongPressGestureRecognizer
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
    
    var boolTrashEmptyFlag = false //垃圾桶空标志 false 桶满,true 桶空
    
    var imageTrashFull : UIImage!
    var imageTrashEmpty : UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = NSBundle.mainBundle()
        let imageTrashFullPath = bundle.pathForResource("Blend Trash Full", ofType: "png")
        let imageTrashEmptyPath = bundle.pathForResource("Blend Trash Empty", ofType: "png")
        
        self.imageTrashFull = UIImage(contentsOfFile: imageTrashFullPath!)
        
        self.imageTrashEmpty = UIImage(contentsOfFile: imageTrashEmptyPath!)
        
        self.imageView.image = self.imageTrashFull
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func foundTap(sender: AnyObject) {
        
        let paramSender = sender as! UILongPressGestureRecognizer
        NSLog("长按 state = %i", paramSender.state.rawValue)

        if (paramSender.state == .Began) { //手势开始
            if boolTrashEmptyFlag {
                self.imageView.image = self.imageTrashFull
                boolTrashEmptyFlag = false
            } else {
                self.imageView.image = self.imageTrashEmpty
                boolTrashEmptyFlag = true
            }
        }
        
    }
}