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

public class NoteDAO {
    //保存数据列表
    //var listData: NSMutableArray!
    
    public class var sharedInstance: NoteDAO {
        struct Static {
            static var instance: NoteDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = NoteDAO()
            Static.instance?.createEditableCopyOfDatabaseIfNeeded()
        }
        return Static.instance!
    }
    
    
    //插入Note方法
    public func create(model: Note) -> Int {
        
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let path = self.applicationDocumentsDirectoryFile()
        var array = NSMutableArray(contentsOfFile: path)!
        
        
        var strDate = dateFormatter.stringFromDate(model.date)
        var dict = NSDictionary(objects: [strDate, model.content], forKeys: ["date", "content"])
        
        array.addObject(dict)
        array.writeToFile(path, atomically: true)
        
        return 0
    }
    
    //删除Note方法
    public func remove(model: Note) -> Int {
        
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let path = self.applicationDocumentsDirectoryFile()
        var array = NSMutableArray(contentsOfFile: path)!
        
        for item in array  {
            var dict = item as! NSDictionary
            var strDate = dict["date"] as! String
            var date = dateFormatter.dateFromString(strDate)
            
            //比较日期主键是否相等
            if date == model.date {
                array.removeObject(dict)
                array.writeToFile(path, atomically: true)
                break
            }
        }
        return 0
    }
    
    //修改Note方法
    public func modify(model: Note) -> Int {
        
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let path = self.applicationDocumentsDirectoryFile()
        var array = NSMutableArray(contentsOfFile: path)!
        
        
        for item in array  {
            var dict = item as! NSDictionary
            var strDate = dict["date"] as! String
            var date = dateFormatter.dateFromString(strDate)
            var content = dict["content"] as! String
            
            //比较日期主键是否相等
            if date == model.date {
                dict.setValue(model.content, forKey: "content")
                array.writeToFile(path, atomically: true)
                break
            }
        }
        return 0
    }
    
    //查询所有数据方法
    public func findAll() -> NSMutableArray {
        
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let path = self.applicationDocumentsDirectoryFile()
        var array = NSMutableArray(contentsOfFile: path)!
        
        var listData = NSMutableArray()
        
        for item in array {
            var dict = item as! NSDictionary
            
            var strDate = dict["date"] as! String
            var date = dateFormatter.dateFromString(strDate)!
            var content = dict["content"] as! String
            
            var note = Note(date:date, content:content)
            
            listData.addObject(note)
        }
        
        return listData
    }
    
    //按照主键查询数据方法
    public func findById(model: Note) -> Note? {
        
        let dateFormatter : NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let path = self.applicationDocumentsDirectoryFile()
        var array = NSMutableArray(contentsOfFile: path)!
        
        for item in array  {
            var dict = item as! NSDictionary
            var strDate = dict["date"] as! String
            var date = dateFormatter.dateFromString(strDate)!
            
            var content = dict["content"] as! String
            
            //比较日期主键是否相等
            if date == model.date {
                var note = Note(date:date, content:content)
                return note
            }
        }
        return nil
    }
    
    func createEditableCopyOfDatabaseIfNeeded() {
        let fileManager = NSFileManager.defaultManager()
        let writableDBPath = self.applicationDocumentsDirectoryFile()
        
        let dbexits = fileManager.fileExistsAtPath(writableDBPath)
        
        if (dbexits != true) {
            let defaultDBPath = NSBundle.mainBundle().resourcePath as String!
            let dbFile = defaultDBPath.stringByAppendingPathComponent("NotesList.plist") as String
            let success = fileManager.copyItemAtPath(dbFile, toPath: writableDBPath, error: nil)
            
            assert(success, "错误写入文件")
        }
    }
    
    func applicationDocumentsDirectoryFile() ->String {
        let  documentDirectory: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let path = documentDirectory[0].stringByAppendingPathComponent("NotesList.plist") as String
        return path
    }
    
}