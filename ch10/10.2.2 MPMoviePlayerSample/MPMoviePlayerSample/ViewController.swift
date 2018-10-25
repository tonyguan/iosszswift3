//
//  ViewController.swift
//  MPMoviePlayerSample
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
import MediaPlayer

class ViewController: UIViewController {

    var moviePlayerView : MPMoviePlayerViewController!
    var moviePlayer : MPMoviePlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func movieURL() -> NSURL {
        let bundle = NSBundle.mainBundle()
        let moviePath = bundle.pathForResource("YY", ofType: "mp4")
        let url =  NSURL(fileURLWithPath: moviePath!)
        return url!
    }

    @IBAction func useMPMoviePlayerController(sender: AnyObject) {
        
        if self.moviePlayer == nil {
            self.moviePlayer = MPMoviePlayerController(contentURL: self.movieURL())
            self.moviePlayer.scalingMode = MPMovieScalingMode.AspectFit
            self.moviePlayer.controlStyle = MPMovieControlStyle.Fullscreen
            self.view.addSubview(self.moviePlayer.view)
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "playbackFinished4MoviePlayerController:",
                name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "doneButtonClick:",
                name: MPMoviePlayerWillExitFullscreenNotification, object: nil)
        }
        
        self.moviePlayer.play()
        self.moviePlayer.setFullscreen(true, animated: true)

    }
    
    @IBAction func useMPMoviePlayerViewController(sender: AnyObject) {
        if self.moviePlayerView == nil {
            self.moviePlayerView = MPMoviePlayerViewController(contentURL: self.movieURL())
            self.moviePlayerView.moviePlayer.scalingMode = MPMovieScalingMode.AspectFill
            self.moviePlayerView.moviePlayer.controlStyle =	MPMovieControlStyle.Embedded
            
            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "playbackFinished4MoviePlayerViewController:",
                name: MPMoviePlayerPlaybackDidFinishNotification, object: nil)

        }
        self.presentMoviePlayerViewControllerAnimated(self.moviePlayerView)
    }
    
    // MARK: --处理通知
    func playbackFinished4MoviePlayerController(notification : NSNotification) {
        NSLog("使用MPMoviePlayerController播放完成.")
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.moviePlayer.stop()
        self.moviePlayer.view.removeFromSuperview()
        self.moviePlayer = nil
    }
    
    func doneButtonClick(notification : NSNotification) {
        NSLog("退出全屏.")
        if self.moviePlayer.playbackState == MPMoviePlaybackState.Stopped {
            self.moviePlayer.view.removeFromSuperview()
            self.moviePlayer = nil
        }
    }
    
    func playbackFinished4MoviePlayerViewController(notification : NSNotification) {
        NSLog("使用MPMoviePlayerViewController播放完成.")
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.moviePlayerView.dismissMoviePlayerViewControllerAnimated()
        self.moviePlayerView = nil
    }
    
}

