//
//  NoteBL.swift
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

import Foundation

//定义BL查询所有数据成功通知
let	BLFindAllFinishedNotification	    = "BLFindAllFinishedNotification"
//定义BL查询所有数据失败通知
let	BLFindAllFailedNotification	        = "BLFindAllFailedNotification"
//定义BL插入数据成功通知
let	BLCreateFinishedNotification        = "BLCreateFinishedNotification"
//定义BL插入数据失败通知
let	BLCreateFailedNotification          = "BLCreateFailedNotification"
//定义BL删除数据成功通知
let	BLRemoveFinishedNotification	    = "BLRemoveFinishedNotification"
//定义BL删除数据失败通知
let	BLRemoveFailedNotification	        = "BLRemoveFailedNotification"
//定义BL修改数据成功通知
let	BLModifyFinishedNotification	    = "BLModifyFinishedNotification"
//定义BL修改数据失败通知
let	BLModifyFailedNotification	        = "BLModifyFailedNotification"


class NoteBL : NSObject {
    
    //插入Note方法
    func createNote(model: Note) {

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "createFinished:", name: DaoCreateFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "createFailed:", name: DaoCreateFailedNotification, object: nil)
        
        var dao:NoteDAO = NoteDAO.sharedInstance
        dao.create(model)
    }
    
    //修改Note方法
    func modifyNote(model: Note) {
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "modifyFinished:", name: DaoModifyFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "modifyFailed:", name: DaoModifyFailedNotification, object: nil)
        
        var dao:NoteDAO = NoteDAO.sharedInstance
        dao.modify(model)
    }
    
    
    //删除Note方法
    func removeNote(model: Note) {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeFinished:", name: DaoRemoveFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeFailed:", name: DaoRemoveFailedNotification, object: nil)
        
        var dao:NoteDAO = NoteDAO.sharedInstance
        dao.remove(model)
    }
    
    //查询所用数据方法
    func findAllNotes() {
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "findAllFinished:", name: DaoFindAllFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "findAllFailed:", name: DaoFindAllFailedNotification, object: nil)
  
        var dao:NoteDAO = NoteDAO.sharedInstance
        dao.findAll()
    }
    
    //MARK: 通知回调方法
    //查询所有数据方法 成功
    func findAllFinished(notification: NSNotification) {
        
        let resList = notification.object as! NSMutableArray
        NSNotificationCenter.defaultCenter().postNotificationName(BLFindAllFinishedNotification, object: resList)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoFindAllFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoFindAllFailedNotification, object: nil)
        
    }
    
    //查询所有数据方法 失败
    func findAllFailed(notification: NSNotification)  {
        
        let error = notification.object as! NSError
        NSNotificationCenter.defaultCenter().postNotificationName(BLFindAllFailedNotification, object: error)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoFindAllFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoFindAllFailedNotification, object: nil)
    
    }
    
    //插入Note方法 成功
    func createFinished(notification: NSNotification)  {
        NSNotificationCenter.defaultCenter().postNotificationName(BLCreateFinishedNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoCreateFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoCreateFailedNotification, object: nil)

    }
    
    //插入Note方法 失败
    func createFailed(notification: NSNotification)  {
        NSNotificationCenter.defaultCenter().postNotificationName(BLCreateFailedNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoCreateFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoCreateFailedNotification, object: nil)
    }
    
    //删除Note方法 成功
    func removeFinished(notification: NSNotification)  {
        
        NSNotificationCenter.defaultCenter().postNotificationName(BLRemoveFinishedNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoRemoveFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoRemoveFailedNotification, object: nil)
    }
    
    //删除Note方法 失败
    func removeFailed(notification: NSNotification)  {
        
        NSNotificationCenter.defaultCenter().postNotificationName(BLRemoveFailedNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoRemoveFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoRemoveFailedNotification, object: nil)
    }
    
    //修改Note方法 成功
    func modifyFinished(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName(BLModifyFinishedNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoRemoveFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoRemoveFailedNotification, object: nil)
    }
    //修改Note方法 失败
    func modifyFailed(notification: NSNotification)  {
        NSNotificationCenter.defaultCenter().postNotificationName(BLModifyFailedNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoModifyFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: DaoModifyFailedNotification, object: nil)
    }
    
}
