//
//  ViewController.swift
//  MusicPlayer
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
import AVFoundation

class ViewController: UIViewController,AVAudioPlayerDelegate {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var btnPlay: UIButton!
    
    var player : AVAudioPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func play(sender: AnyObject) {
        
        var error:NSError?
        
        if self.player == nil {
            
            let path = NSBundle.mainBundle().pathForResource("test", ofType: "caf")
            let url = NSURL(fileURLWithPath: path!)
            
            self.player = AVAudioPlayer(contentsOfURL: url!, error: &error)
            self.player.prepareToPlay()
            self.player.numberOfLoops  = -1
            
            if error != nil {
                NSLog("%@",error!.description)
                self.label.text = "播放错误。"
                return
            }
            player.delegate = self
        }
        
        if !self.player.playing {
            player.play()
            self.label.text = "播放中..."
            let pauseImage = UIImage(named: "pause")
            self.btnPlay.setImage(pauseImage, forState: UIControlState.Normal)
        } else {
            player.pause()
            self.label.text = "播放暂停。"
            let playImage = UIImage(named: "play")
            self.btnPlay.setImage(playImage, forState: UIControlState.Normal)
        }
    }
    
    @IBAction func stop(sender: AnyObject) {
        
        if self.player != nil {
            self.player.stop()
            self.player.delegate = nil
            self.player = nil
            self.label.text = "播放停止。"
            let playImage = UIImage(named: "play")
            self.btnPlay.setImage(playImage, forState: UIControlState.Normal)
        }
        
    }
    
    // MARK: --实现AVAudioPlayerDelegate协议方法
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        NSLog("播放完成。")
        self.label.text = "播放完成。"
        let playImage = UIImage(named: "play")
        self.btnPlay.setImage(playImage, forState: UIControlState.Normal)
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        NSLog("播放错误发生: %@", error.localizedDescription)
        self.label.text = "播放错误。"
        let playImage = UIImage(named: "play")
        self.btnPlay.setImage(playImage, forState: UIControlState.Normal)
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
        NSLog("播放中断。")
        self.label.text = "播放中断。"
        let playImage = UIImage(named: "play")
        self.btnPlay.setImage(playImage, forState: UIControlState.Normal)
    }
    
    func audioPlayerEndInterruption(player: AVAudioPlayer!) {
        NSLog("中断返回。")
        self.label.text = "中断返回。"
        let playImage = UIImage(named: "play")
        self.btnPlay.setImage(playImage, forState: UIControlState.Normal)
    }

    
}

