//
//  DetailViewController.swift
//  MyNotes
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

class DetailViewController: UIViewController, NSURLConnectionDataDelegate {
    
    //接收从服务器返回数据。
    var datas : NSMutableData!
    
    @IBOutlet weak var txtView: UITextView!
    
    //业务逻辑对象BL
    //    var bl = NoteBL()
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let dict: NSDictionary = self.detailItem as? NSDictionary {
            let content = dict["Content"] as! String
            if self.txtView != nil {
                self.txtView.text = content
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onclickSave(sender: AnyObject) {
        self.startRequest()
        self.txtView.resignFirstResponder()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: --开始请求Web Service
    func startRequest()
    {
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let date = NSDate()
        let dateStr = dateFormatter.stringFromDate(date)
        
        let dict = self.detailItem as! NSDictionary
        let id = dict["ID"] as! NSNumber
        
        var strURL = "http://www.51work6.com/service/mynotes/WebService.php"
        var post = String(format: "email=%@&type=%@&action=%@&date=%@&content=%@&id=%@", "<你的51work6.com用户邮箱>", "JSON", "modify",dateStr, self.txtView.text, id)
        
        var postData: NSData = post.dataUsingEncoding(NSUTF8StringEncoding)!
        
        let url = NSURL(string: strURL)!
        
        var request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.HTTPBody = postData
        
        var connection  = NSURLConnection(request: request, delegate: self)
        
        if connection != nil {
            self.datas = NSMutableData()
        }
        
    }
    
    // MARK: --NSURLConnection 回调方法
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        self.datas.appendData(data)
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        NSLog("%@",error.localizedDescription)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        NSLog("请求完成...")
        
        var resDict = NSJSONSerialization.JSONObjectWithData(self.datas, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary!
        
        let resultCode: NSNumber = resDict.objectForKey("ResultCode") as! NSNumber
        var message = "操作成功。"
        
        if (resultCode.integerValue < 0) {
            message = resultCode.errorMessage
        }
        
        let alertView = UIAlertView(title: "提示信息", message: message,
            delegate: nil, cancelButtonTitle: "OK")
        
        alertView.show()
        
    }
    
}

