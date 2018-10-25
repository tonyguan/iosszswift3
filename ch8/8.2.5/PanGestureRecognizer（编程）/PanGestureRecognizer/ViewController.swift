//
//  ViewController.swift
//  PanGestureRecognizer
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
    
    var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recognizer = UIPanGestureRecognizer(target: self, action: "foundTap:")
        recognizer.minimumNumberOfTouches = 1
        recognizer.maximumNumberOfTouches = 1
        
        let bundle = NSBundle.mainBundle()
        let imageTrashFullPath = bundle.pathForResource("Blend Trash Full", ofType: "png")
        
        self.imageView = UIImageView()
        self.imageView.image = UIImage(contentsOfFile: imageTrashFullPath!)
        self.imageView.frame = CGRectMake(96.0, 68.0, 128.0, 128.0)
        self.imageView.userInteractionEnabled = true
        
        self.view.addSubview(self.imageView)
        
        self.imageView.addGestureRecognizer(recognizer)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func foundTap(paramSender : UIPanGestureRecognizer) {
        
        NSLog("平移 state = %i", paramSender.state.rawValue)
        
        if (paramSender.state != .Ended &&
            paramSender.state != .Failed){
                let location = paramSender.locationInView(paramSender.view!.superview)
                paramSender.view!.center = location
        }
    }
    
}

