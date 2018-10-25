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
    
    var previousDistance : CGFloat = 0.0
    var zoomFactor : CGFloat = 1.0
    var pinchZoom  = false
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = NSBundle.mainBundle()
        let imageTrashFullPath = bundle.pathForResource("Blend Trash Full", ofType: "png")
        self.imageTrashFull = UIImage(contentsOfFile: imageTrashFullPath!)
        
        self.imageView.image = self.imageTrashFull
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        if touches.count == 2 {
            self.pinchZoom = true
            
            let arrayTouches = Array(touches)
            let touchOne = arrayTouches[0] as! UITouch
            let touchTwo = arrayTouches[1] as! UITouch

            let pointOne = touchOne.locationInView(self.view)
            let pointTwo = touchTwo.locationInView(self.view)
            
            self.previousDistance = sqrt(pow(pointOne.x - pointTwo.x, 2.0) +
                pow(pointOne.y - pointTwo.y, 2.0))

        } else {
            self.pinchZoom = false
        }
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if self.pinchZoom == true && touches.count == 2 {
            
            let arrayTouches = Array(touches)
            let touchOne = arrayTouches[0] as! UITouch
            let touchTwo = arrayTouches[1] as! UITouch
            
            let pointOne = touchOne.locationInView(self.view)
            let pointTwo = touchTwo.locationInView(self.view)
            
            let distance = sqrt(pow(pointOne.x - pointTwo.x, 2.0) +
                pow(pointOne.y - pointTwo.y, 2.0))
            zoomFactor += (distance - previousDistance) / previousDistance
            if zoomFactor > 0 {
                previousDistance = distance
                self.imageView.transform = CGAffineTransformMakeScale(zoomFactor, zoomFactor)
            }

        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if touches.count != 2 {
            self.pinchZoom = false
            self.previousDistance = 0.0
        }
    }
}

