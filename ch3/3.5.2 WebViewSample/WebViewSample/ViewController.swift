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

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView = WKWebView(frame: CGRectMake(0, 100, self.view.bounds.width, self.view.bounds.height))
        self.view.addSubview(self.webView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func testLoadHTMLString(sender: AnyObject) {
        
        let htmlPath = NSBundle.mainBundle().pathForResource("index", ofType: "html")
        let bundleUrl = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath)
        
        var error: NSError?
        let html = String(contentsOfFile: htmlPath!, encoding: NSUTF8StringEncoding, error: &error)
        
        if (error == nil) {
            self.webView.loadHTMLString(html!, baseURL: bundleUrl)
        }
    }
    
    @IBAction func testLoadRequest(sender: AnyObject) {
        let url = NSURL(string: "http://51work6.com")
        let request = NSURLRequest(URL: url!)
        self.webView.loadRequest(request)
        self.webView.navigationDelegate = self
    }
    
    //开始加载时调用
    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        NSLog("didStartProvisionalNavigation")
    }
    
    //当内容开始返回时调用
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        NSLog("didCommitNavigation")
    }
    
    //加载完成之后调用
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        NSLog("didFinishNavigation")
    }
    
    //加载失败时调用
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog("didFailProvisionalNavigation")
    }
    
}

