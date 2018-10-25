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

protocol NoteDAODelegate {
    
    //查询所有数据方法 成功
    func findAllFinished(list : NSMutableArray)
    
    //查询所有数据方法 失败
    func findAllFailed(error : NSError)
    
    //按照主键查询数据方法 成功
    func findByIdFinished(model : Note)
    
    //按照主键查询数据方法 失败
    func findByIdFailed(error : NSError)
    
    //插入Note方法 成功
    func createFinished()
    
    //插入Note方法 失败
    func createFailed(error : NSError)
    
    //删除Note方法 成功
    func removeFinished()
    
    //删除Note方法 失败
    func removeFailed(error : NSError)
    
    //修改Note方法 成功
    func modifyFinished()
    
    //修改Note方法 失败
    func modifyFailed(error : NSError)
    
}


class NoteDAO : NSObject {
    
    let HOST_PATH = "/service/mynotes/WebService.php"
    let HOST_NAME = "51work6.com"
    let USER_ID = "<你的51work6.com用户邮箱>"
    
    var delegate: NoteDAODelegate!
    
    //保存数据列表
    var listData: NSMutableArray!
    
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
            
            NSLog("responseData : %@", operation.responseString())
            let data  = operation.responseData()
            let resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)  as! NSDictionary
            
            let resultCodeNumber: NSNumber = resDict.objectForKey("ResultCode") as! NSNumber
            let resultCode = resultCodeNumber.integerValue
            
            if resultCode >= 0 {
                self.delegate.createFinished()
            } else {
                let message = resultCodeNumber.errorMessage
                let userInfo = [NSLocalizedDescriptionKey : message]
                let err = NSError(domain:"DAO", code:resultCode, userInfo: userInfo)
                
                self.delegate.createFailed(err)
            }
            
        }, errorHandler: { (operation, err) -> Void in
            NSLog("MKNetwork请求错误 : %@", err.localizedDescription)
            self.delegate.createFailed(err)
                
        })
        engine.enqueueOperation(op)
        
    }
    
    //删除Note方法
    func remove(model: Note) {
        
        var engine = MKNetworkEngine(hostName: HOST_NAME, customHeaderFields: nil)
        
        var param = ["email": USER_ID]
        param["type"] = "JSON"
        param["action"] = "remove"
        param["date"] = model.date
        param["id"] = model.ID
        
        var op = engine.operationWithPath(HOST_PATH, params: param, httpMethod:"POST")
        
        op.addCompletionHandler({ (operation) -> Void in
            
            NSLog("responseData : %@", operation.responseString())
            let data  = operation.responseData()
            let resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)  as! NSDictionary
            
            let resultCodeNumber: NSNumber = resDict.objectForKey("ResultCode") as! NSNumber
            let resultCode = resultCodeNumber.integerValue
            
            if resultCode >= 0 {
                self.delegate.removeFinished()
            } else {
                let message = resultCodeNumber.errorMessage
                let userInfo = [NSLocalizedDescriptionKey : message]
                let err = NSError(domain:"DAO", code:resultCode, userInfo: userInfo)
                
                self.delegate.removeFailed(err)
            }
            
            }, errorHandler: { (operation, err) -> Void in
                NSLog("MKNetwork请求错误 : %@", err.localizedDescription)
                self.delegate.removeFailed(err)
                
        })
        engine.enqueueOperation(op)
        
    }
    
    //修改Note方法
    func modify(model: Note) {
        
        var engine = MKNetworkEngine(hostName: HOST_NAME, customHeaderFields: nil)
        
        var param = ["email": USER_ID]
        param["type"] = "JSON"
        param["action"] = "modify"
        param["date"] = model.date
        param["id"] = model.ID
        param["content"] = model.content
        
        var op = engine.operationWithPath(HOST_PATH, params: param, httpMethod:"POST")
        
        op.addCompletionHandler({ (operation) -> Void in
            
            NSLog("responseData : %@", operation.responseString())
            let data  = operation.responseData()
            let resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil)  as! NSDictionary
            
            let resultCodeNumber: NSNumber = resDict.objectForKey("ResultCode") as! NSNumber
            let resultCode = resultCodeNumber.integerValue
            
            if resultCode >= 0 {
                self.delegate.modifyFinished()
            } else {
                let message = resultCodeNumber.errorMessage
                let userInfo = [NSLocalizedDescriptionKey : message]
                let err = NSError(domain:"DAO", code:resultCode, userInfo: userInfo)
                
                self.delegate.modifyFailed(err)
            }
            
            }, errorHandler: { (operation, err) -> Void in
                NSLog("MKNetwork请求错误 : %@", err.localizedDescription)
                self.delegate.modifyFailed(err)
                
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
                
                self.delegate.findAllFinished(listData)
                
            } else {
                let message = resultCodeNumber.errorMessage
                let userInfo = [NSLocalizedDescriptionKey : message]
                
                let err = NSError(domain:"DAO", code:resultCode, userInfo: userInfo)
                
                self.delegate.findAllFailed(err)
            }
            
            }, errorHandler: { (operation, err) -> Void in
                NSLog("MKNetwork请求错误 : %@", err.localizedDescription)
                self.delegate.findAllFailed(err)
                
        })
        engine.enqueueOperation(op)
        
    }    
}
