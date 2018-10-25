//
//  ViewController.swift
//  PinchGestureRecognizer
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
    
    var imageTrashFull : UIImage!
    
    var currentScale : CGFloat  = 1.0
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = NSBundle.mainBundle()
        let imageTrashFullPath = bundle.pathForResource("Blend Trash Full", ofType: "png")
        self.imageTrashFull = UIImage(contentsOfFile: imageTrashFullPath!)
        
        self.imageView.image = self.imageTrashFull
        
        let recognizer = UIPinchGestureRecognizer(target:self, action:"foundTap:")
        self.view.addGestureRecognizer(recognizer)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func foundTap(paramSender: UIPinchGestureRecognizer) {
        
        if paramSender.state == .Ended {
            currentScale = paramSender.scale
        } else if paramSender.state == .Began && currentScale != 0.0 {
            paramSender.scale = currentScale
        }
        
        self.imageView.transform = CGAffineTransformMakeScale(paramSender.scale, paramSender.scale)
        
    }
}

