//
//  NoteDAO.swift
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


//定义DAO查询所有数据成功通知
let	DaoFindAllFinishedNotification 	    = "DaoFindAllFinishedNotification"
//定义DAO查询所有数据失败通知
let	DaoFindAllFailedNotification	    = "DaoFindAllFailedNotification"
//定义DAO通过ID查询数据成功通知
let	DaoFindIdFinishedNotification	    = "DaoFindIdFinishedNotification"
//定义DAO通过ID查询数据失败通知
let	DaoFindIdFailedNotification	        = "DaoFindIdFailedNotification"
//定义DAO插入数据成功通知
let	DaoCreateFinishedNotification	    = "DaoCreateFinishedNotification"
//定义DAO插入数据失败通知
let	DaoCreateFailedNotification	        = "DaoCreateFailedNotification"
//定义DAO删除数据成功通知
let	DaoRemoveFinishedNotification	    = "DaoRemoveFinishedNotification"
//定义DAO删除数据失败通知
let	DaoRemoveFailedNotification	        = "DaoRemoveFailedNotification"
//定义DAO修改数据成功通知
let	DaoModifyFinishedNotification	    = "DaoModifyFinishedNotification"
//定义DAO修改数据失败通知
let	DaoModifyFailedNotification	        = "DaoModifyFailedNotification"


let HOST_PATH = "/service/mynotes/WebService.php"
let HOST_NAME = "51work6.com"
let USER_ID = "<你的51work6.com用户邮箱>"

class NoteDAO : NSObject {
    
    
    class var sharedInstance: NoteDAO {
        struct Static {
            static var instance: NoteDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = NoteDAO()
        }
        return Static.instance!
    }
    
    
    //插入Note方法
    func create(model: Note) {
        
        var engine = MKNetworkEngine(hostName: HOST_NAME, customHeaderFields: nil)
        
        var param = ["email": USER_ID]
        param["type"] = "JSON"
        param["action"] = "add"
        param["date"] = model.date
        param["content"] = model.content
        
        var op = engine.operationWithPath(HOST_PATH, params: param, httpMethod:"POST")
        
        op.addCompletionHandler({ (operation) -> Void in
            
            NSLog("responseData : %@ ", operation.responseString())
            let data  = operation.responseData()
            let resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)  as! NSDictionary
            
            let resultCodeNumber: NSNumber = resDict.objectForKey("ResultCode") as! NSNumber
            let resultCode = resultCodeNumber.integerValue
            
            if resultCode >= 0 {
                NSNotificationCenter.defaultCenter().postNotificationName(DaoCreateFinishedNotification, object: nil)
            } else {
                let message = resultCodeNumber.errorMessage
                let userInfo = [NSLocalizedDescriptionKey : message]
                let err = NSError(domain:"DAO", code:resultCode, userInfo: userInfo)
                
                NSNotificationCenter.defaultCenter().postNotificationName(DaoCreateFailedNotification, object: err)
            }
            
            }, errorHandler: { (operation, err) -> Void in
                NSLog("MKNetwork请求错误 : %@ ", err.localizedDescription)
                NSNotificationCenter.defaultCenter().postNotificationName(DaoCreateFailedNotification, object: err)
        })
        engine.enqueueOperation(op)
        
    }
    
    //删除Note方法
    func remove(model: Note) {
        
        var engine = MKNetworkEngine(hostName: HOST_NAME, customHeaderFields: nil)
        
        var param = ["email": USER_ID]
        param["type"] = "JSON"
        param["action"] = "remove"
        param["id"] = model.ID
        
        var op = engine.operationWithPath(HOST_PATH, params: param, httpMethod:"POST")
        
        op.addCompletionHandler({ (operation) -> Void in
            
            NSLog("responseData : %@ ", operation.responseString())
            let data  = operation.responseData()
            let resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)  as! NSDictionary
            
            let resultCodeNumber: NSNumber = resDict.objectForKey("ResultCode") as! NSNumber
            let resultCode = resultCodeNumber.integerValue
            
            if resultCode >= 0 {
                NSNotificationCenter.defaultCenter().postNotificationName(DaoRemoveFinishedNotification, object: nil)
            } else {
                let message = resultCodeNumber.errorMessage
                let userInfo = [NSLocalizedDescriptionKey : message]
                let err = NSError(domain:"DAO", code:resultCode, userInfo: userInfo)
                
                NSNotificationCenter.defaultCenter().postNotificationName(DaoRemoveFailedNotification, object: err)
            }
            
            }, errorHandler: { (operation, err) -> Void in
                NSLog("MKNetwork请求错误 : %@ ", err.localizedDescription)
                NSNotificationCenter.defaultCenter().postNotificationName(DaoRemoveFailedNotification, object: err)
                
        })
        engine.enqueueOperation(op)
        
    }
    
    //修改Note方法
    func modify(model: Note) {
        
        var engine = MKNetworkEngine(hostName: HOST_NAME, customHeaderFields: nil)
            
        var param = ["email": USER_ID]
        param["type"] = "JSON"
        param["action"] = "modify"
        param["id"] = model.ID
        param["date"] = model.date
        param["content"] = model.content
        
        var op = engine.operationWithPath(HOST_PATH, params: param, httpMethod:"POST")
        
        op.addCompletionHandler({ (operation) -> Void in
            
            NSLog("responseData : %@ ", operation.responseString())
            let data  = operation.responseData()
            let resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)  as! NSDictionary
            
            let resultCodeNumber: NSNumber = resDict.objectForKey("ResultCode") as! NSNumber
            let resultCode = resultCodeNumber.integerValue
            
            if resultCode >= 0 {
                NSNotificationCenter.defaultCenter().postNotificationName(DaoModifyFinishedNotification, object: nil)
            } else {
                let message = resultCodeNumber.errorMessage
                let userInfo = [NSLocalizedDescriptionKey : message]
                let err = NSError(domain:"DAO", code:resultCode, userInfo: userInfo)
                NSNotificationCenter.defaultCenter().postNotificationName(DaoModifyFailedNotification, object: err)
            }
            
            }, errorHandler: { (operation, err) -> Void in
                NSLog("MKNetwork请求错误 : %@ ", err.localizedDescription)
                NSNotificationCenter.defaultCenter().postNotificationName(DaoModifyFailedNotification, object: err)
                
        })
        engine.enqueueOperation(op)
    }
    
    //查询所有数据方法
    func findAll() {
        
        var engine = MKNetworkEngine(hostName: HOST_NAME, customHeaderFields: nil)
        
        var param = ["email": USER_ID]
        param["type"] = "JSON"
        param["action"] = "query"
         
        var op = engine.operationWithPath(HOST_PATH, params: param, httpMethod:"POST")
        
        op.addCompletionHandler({ (operation) -> Void in
            
            NSLog("responseData : %@", operation.responseString())
            let data  = operation.responseData()
            let resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)  as! NSDictionary
            
            let resultCodeNumber: NSNumber = resDict.objectForKey("ResultCode") as! NSNumber
            let resultCode = resultCodeNumber.integerValue
            
            if resultCode >= 0 {
                
                let listDict = resDict.objectForKey("Record") as! NSMutableArray
                var listData = NSMutableArray()
                
                for dic in listDict {
                    let row = dic as! NSDictionary
                    
                    let _id  = row.objectForKey("ID") as! NSNumber
                    let strDate  = row.objectForKey("CDate") as! String
                    let content = row.objectForKey("Content") as! String
                    
                    var note = Note(id: _id.stringValue, date:strDate, content: content)
                    
                    listData.addObject(note)
                }
                NSNotificationCenter.defaultCenter().postNotificationName(DaoFindAllFinishedNotification, object: listData)
                
            } else {
                let message = resultCodeNumber.errorMessage
                let userInfo = [NSLocalizedDescriptionKey : message]
                let err = NSError(domain:"DAO", code:resultCode, userInfo: userInfo)
                
                NSNotificationCenter.defaultCenter().postNotificationName(DaoFindAllFailedNotification, object: err)
            }
            
            }, errorHandler: { (operation, err) -> Void in
                NSLog("MKNetwork请求错误 : %@ ", err.localizedDescription)
                NSNotificationCenter.defaultCenter().postNotificationName(DaoFindAllFailedNotification, object: err)
                
        })
        engine.enqueueOperation(op)
        
    }    
}
