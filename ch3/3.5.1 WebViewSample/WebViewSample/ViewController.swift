//
//  ViewController.swift
//  WebViewSample
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
import WebKit

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func testLoadHTMLString(sender: AnyObject) {
        
        let htmlPath = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        let bundleUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)
        
        var error: NSError?
        let html = String(contentsOfFile: htmlPath!, encoding: NSUTF8StringEncoding, error: &error)
        
        if (error == nil) {
            self.webView.loadHTMLString(html, baseURL: bundleUrl)
        }
    }
    
    @IBAction func testLoadRequest(sender: AnyObject) {
        let url = NSURL(string: "http://51work6.com")
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        self.webView.delegate = self
    }
    
    //UIWebViewDelegate委托定义方法
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        NSLog("error : %@", error)
    }
    
    //UIWebViewDelegate委托定义方法
    func webViewDidFinishLoad(webView: UIWebView) {
        NSLog("%@", webView.stringByEvaluatingJavaScriptFromString("document.body.innerHTML")!)
    }

}

