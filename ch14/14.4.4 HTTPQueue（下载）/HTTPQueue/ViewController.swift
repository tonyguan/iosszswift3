//
//  ViewController.swift
//  HTTPQueue
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
    
    
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var imageView1: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClick(sender: AnyObject) {
        
        self.imageView1.image = nil
        
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let cachesDirectory = paths[0] as! String
        let downloadPath = cachesDirectory.stringByAppendingPathComponent("test1.jpg")
        
        var path = String(format: "/service/download.php?email=%@&FileName=test1.jpg", "<你的51work6.com用户邮箱>")
        path = path.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var engine = MKNetworkEngine(hostName: "51work6.com", customHeaderFields: nil)
        
        var downloadOperation = engine.operationWithPath(path, params: nil, httpMethod: "POST")
        var os = NSOutputStream(toFileAtPath: downloadPath, append: false)
        downloadOperation.addDownloadStream(os)
        
        downloadOperation.onDownloadProgressChanged { (progress) -> Void in
            NSLog("download progress: %.2f%%", progress*100.0)
            self.progressView.progress = Float(progress)
        }
        
        downloadOperation.addCompletionHandler({ (operation) -> Void in
            NSLog("download progress: 100%%")
            NSLog("download file finished!")
            var data = operation.responseData()
            
            if data != nil {
                //返回数据失败
                var resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary!
                
                if resDict != nil {
                    let resultCode: NSNumber = resDict.objectForKey("ResultCode") as! NSNumber
                    
                    if (resultCode.integerValue < 0) {
                        let errorStr = resultCode.errorMessage
                        let alertView = UIAlertView(title: "错误信息", message: errorStr,
                            delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                    }
                }
                
            } else {
                //返回数据成功
                var img = UIImage(contentsOfFile: downloadPath)
                self.imageView1.image = img
            }
            
            }, errorHandler: { (errorOp, err) -> Void in
                NSLog("MKNetwork请求错误 : %@", err.localizedDescription)
        })
        
        engine.enqueueOperation(downloadOperation)

    }
    
}

