//
//  AddViewController.swift
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

class AddViewController: UIViewController, UITextViewDelegate,UIAlertViewDelegate, NoteBLDelegate {
    
    //接收从服务器返回数据。
    var datas : NSMutableData!
    //业务逻辑对象BL
    var bl: NoteBL = NoteBL()
    
    @IBOutlet weak var txtView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtView.delegate = self
        self.bl.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onclickSave(sender: AnyObject) {
        
        let date = NSDate()
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.stringFromDate(date)
        
        var note = Note(id:nil , date: strDate ,content: self.txtView.text)
        
        self.bl.createNote(note)
        
        self.txtView.resignFirstResponder()
    }
    
    @IBAction func onclickCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //UITextView Delegate  Method
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //UIAlertView Delegate  Method
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        println("buttonIndex = \(buttonIndex)")
        
        if buttonIndex == 0 {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else if buttonIndex == 1 {
            self.txtView.text = ""
        }
    }
    
    // MARK:- 处理通知
    //插入Note方法 成功
    func createNoteFinished(){
        
        let alertView = UIAlertView(title: "操作信息",
            message: "插入成功。",
            delegate: self,
            cancelButtonTitle: "返回",
            otherButtonTitles:"继续")
        
        alertView.show()
    }
    
    //插入Note方法 失败
    func createNoteFailed(error : NSError) {
        let errorStr = error.localizedDescription
        
        let alertView = UIAlertView(title: "操作信息",
            message: errorStr,
            delegate: self,
            cancelButtonTitle: "返回",
            otherButtonTitles:"继续")
        
        alertView.show()
    }
    
    //修改Note方法 成功
    func modifyNoteFinished() { }
    
    //修改Note方法 失败
    func modifyNoteFailed(error : NSError) { }
    
    //查询所有数据方法 成功
    func findAllNotesFinished(list : NSMutableArray) {  }
    
    //查询所有数据方法 失败
    func findAllNotesFailed(error : NSError) {  }
    
    
    //删除Note方法 成功
    func removeNoteFinished() {}
    
    //删除Note方法 失败
    func removeNoteFailed(error : NSError) {}

}
