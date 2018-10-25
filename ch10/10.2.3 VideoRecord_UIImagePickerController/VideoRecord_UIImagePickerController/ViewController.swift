//
//  ViewController.swift
//  VideoRecord_UIImagePickerController
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
import MobileCoreServices


class ViewController: UIViewController,UIImagePickerControllerDelegate,
    UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func videoRecod(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            
            var imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .Camera
            imagePickerController.mediaTypes = [kUTTypeMovie]
            
            //录制质量设定
            imagePickerController.videoQuality = .TypeHigh
            
            //只允许最多录制30秒时间
            imagePickerController.videoMaximumDuration = 30.0
            
            self.presentViewController(imagePickerController, animated: true, completion: nil)
            
        } else {
            NSLog("摄像头不可用。")
        }
    }
    
    // MARK: --实现委托协议UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let url = info[UIImagePickerControllerMediaURL] as! NSURL
        var tempFilePath = url.path
        
        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(tempFilePath) {
            UISaveVideoAtPathToSavedPhotosAlbum(tempFilePath!, self, "video:didFinishSavingWithError:contextInfo:", nil)
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    //定义回调方法video:didFinishSavingWithError:contextInfo:
    func video(video: NSString, didFinishSavingWithError error : NSError?, contextInfo:UnsafeMutablePointer<Void>){
        
        var title = ""
        var message = ""
        
        if error != nil {
            title = "视频失败"
            message = error!.localizedDescription
        } else {
            title = "视频保存"
            message = "视频已经保存到设备的相机胶卷中"
        }
        
        let alert = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
        alert.show()
    }
    
    // MARK: --实现委托协议UINavigationControllerDelegate
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
         NSLog("选择器将要显示。")
    }
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        NSLog("选择器显示结束。")
    }
    
}

