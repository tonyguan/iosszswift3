//
//  ViewController.swift
//  RotationGestureRecognizer
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
    
    var rotationAngleInRadians : CGFloat = 0
    
    var imageTrashFull : UIImage!
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = NSBundle.mainBundle()
        let imageTrashFullPath = bundle.pathForResource("Blend Trash Full", ofType: "png")
        self.imageTrashFull = UIImage(contentsOfFile: imageTrashFullPath!)
        
        self.imageView.image = self.imageTrashFull
        
        let recognizer = UIRotationGestureRecognizer(target: self, action: "foundTap:")
        
        self.view.addGestureRecognizer(recognizer)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func foundTap(paramSender: UIRotationGestureRecognizer) {
        
        /* 上一次角度加上本次旋转的角度 */
        self.imageView.transform =  CGAffineTransformMakeRotation(rotationAngleInRadians + paramSender.rotation)
        
        /* 手势识别完成，保存旋转的角度 */
        if (paramSender.state == .Ended){
            rotationAngleInRadians += paramSender.rotation
        }
    }
    
}