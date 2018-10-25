//
//  ViewController.swift
//  ImageSample
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

let FILE_NAME = "flower.png"

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        //复制图片到沙箱目录下
        self.createEditableCopyOfDatabaseIfNeeded()
        self.imageView.image = UIImage(named:"SkyDrive340.png")
    }

    func createEditableCopyOfDatabaseIfNeeded() {
        let fileManager = NSFileManager.defaultManager()
        let writableDBPath = applicationDocumentsDirectoryFile()

        let dbexits =  fileManager.fileExistsAtPath(writableDBPath)

        if !dbexits {
            let  defaultDBPath = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(FILE_NAME)
            
            var error: NSError? = nil
            let success = fileManager.copyItemAtPath(defaultDBPath!, toPath : writableDBPath, error: &error)
            
            if !success {
                NSLog("错误写入文件: %@。", error!.localizedDescription)
            }
        }
    }
    
    func applicationDocumentsDirectoryFile() -> String {
    
        let  documentDirectorys: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        let documentDirectory = documentDirectorys[0] as! String
        let path = documentDirectory.stringByAppendingPathComponent(FILE_NAME)

        return path
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loadBundle(sender: AnyObject) {
        
        let path = NSBundle.mainBundle().pathForResource("SkyDrive340", ofType:"png")
        let image = UIImage(contentsOfFile:path!)
        
        self.imageView.image = UIImage(named:"SkyDrive340.png")
    }

    @IBAction func loadSandbox(sender: AnyObject) {
        let path = self.applicationDocumentsDirectoryFile()
        self.imageView.image = UIImage(contentsOfFile:path)
    }
    
    
    @IBAction func loadWebService(sender: AnyObject) {
        let strURL = String(format: "http://www.51work6.com/service/download.php?email=%@&FileName=2004-2OH.jpg", "<您的http://51work6.com网站注册邮箱>")
        let url = NSURL(string: strURL)
        let data = NSData(contentsOfURL:url!)
        
        self.imageView.image = UIImage(data: data!)
    }
}

