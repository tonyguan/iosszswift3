//
//  DetailViewController.swift
//  TreeNavigation
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

class DetailViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var webView: UIWebView!
    
    var url: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = NSURL(string: self.url)
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        self.webView.delegate = self
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UIWebViewDelegate委托定义方法
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        NSLog("error : %@", error)
    }
    
    //UIWebViewDelegate委托定义方法
    func webViewDidFinishLoad(webView: UIWebView) {
        NSLog("finish")
    }
    
}
