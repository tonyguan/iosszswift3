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

class DetailViewController: UIViewController, UITextViewDelegate, NoteBLDelegate {
    
    //接收从服务器返回数据。
    var datas : NSMutableData!
    //业务逻辑对象BL
    var bl: NoteBL = NoteBL()    
    
    @IBOutlet weak var txtView: UITextView!
    
    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let note: Note = self.detailItem as? Note {
            let content = note.content as String?
            if self.txtView != nil {
                self.txtView.text = content
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        self.txtView.delegate = self
        
        self.bl.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //UITextView Delegate  Method
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    @IBAction func onclickSave(sender: AnyObject) {
        
        var note = self.detailItem as! Note
        note.content = self.txtView.text
        self.bl.modifyNote(note)
        
        self.txtView.resignFirstResponder()
    }
    
    // MARK:- 处理通知    
    //修改Note方法 成功
    func modifyNoteFinished() {
        let alertView = UIAlertView(title: "操作信息",
            message: "修改成功。",
            delegate: nil,
            cancelButtonTitle: "OK")
        
        alertView.show()
    }
    
    //修改Note方法 失败
    func modifyNoteFailed(error : NSError) {
        
        let errorStr = error.localizedDescription
        
        let alertView = UIAlertView(title: "操作信息",
            message: errorStr,
            delegate: nil,
            cancelButtonTitle: "OK")
        
        alertView.show()
    }
    
    //查询所有数据方法 成功
    func findAllNotesFinished(list : NSMutableArray) {  }
    
    //查询所有数据方法 失败
    func findAllNotesFailed(error : NSError) {  }

    
    //删除Note方法 成功
    func removeNoteFinished() {}
    
    //删除Note方法 失败
    func removeNoteFailed(error : NSError) {}
    
    //插入Note方法 成功
    func createNoteFinished(){}
    
    //插入Note方法 失败
    func createNoteFailed(error : NSError){}
}

