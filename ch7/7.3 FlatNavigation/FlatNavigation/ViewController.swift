//
//  ViewController.swift
//  FlatNavigation
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

class ViewController: UIViewController , UIScrollViewDelegate {
    
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!
    
    var viewHeight:CGFloat = 0.0
    var viewWidth:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewHeight = self.view.frame.size.height
        viewWidth = self.view.frame.size.width
        
        //创建ScrollView
        self.scrollView = UIScrollView(frame: self.view.frame)
        self.scrollView.contentSize  = CGSizeMake(self.view.frame.size.width*3, self.scrollView.frame.size.height)
        self.scrollView.pagingEnabled = true
        
        self.scrollView.delegate = self
        
        let image1 = UIImage(named: "Image1")
        var imageView1 = UIImageView(image: image1)
        imageView1.frame = CGRectMake(0.0, 0.0, viewWidth, viewHeight)
        self.scrollView.addSubview(imageView1)
        
        let image2 = UIImage(named: "Image2")
        var imageView2 = UIImageView(image: image2)
        imageView2.frame = CGRectMake(viewWidth, 0.0, viewWidth, viewHeight)
        self.scrollView.addSubview(imageView2)
        
        let image3 = UIImage(named: "Image3")
        var imageView3 = UIImageView(image: image3)
        imageView3.frame = CGRectMake(viewWidth * 2, 0.0, viewWidth, viewHeight)
        self.scrollView.addSubview(imageView3)
        
        self.view.addSubview(self.scrollView)
        
        //创建PageControl
        var pageControlHeight:CGFloat = 38.0
        var pageControlWidth:CGFloat = 120.0
        let pageControlFrame = CGRectMake((viewWidth-pageControlWidth)/2 , (viewHeight-pageControlHeight), pageControlWidth, pageControlHeight)
        
        self.pageControl = UIPageControl(frame: pageControlFrame)
        self.pageControl.backgroundColor = UIColor.blackColor()
        self.pageControl.alpha = 0.5
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        
        self.pageControl.addTarget(self, action: "changePage:", forControlEvents: UIControlEvents.ValueChanged)
        
        self.view.addSubview(self.pageControl)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //实现UIScrollViewDelegate协议
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var offset = scrollView.contentOffset
        self.pageControl.currentPage = Int(offset.x) / Int(viewWidth)
    }
    
    //响应PageControl默认事件处理
    func changePage(sender: AnyObject) {
        UIView.animateWithDuration(0.3, animations : {
            var whichPage = self.pageControl.currentPage
            self.scrollView.contentOffset = CGPointMake(self.viewWidth * CGFloat(whichPage), 0)
        })
    }
}

