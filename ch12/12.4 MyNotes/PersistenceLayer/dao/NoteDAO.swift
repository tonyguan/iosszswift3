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

class NoteDAO {
    
    let DBFILE_NAME = "NotesList.sqlite3"
    var db:COpaquePointer = nil
    
    class var sharedInstance: NoteDAO {
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
    
    
    func createEditableCopyOfDatabaseIfNeeded() {
        
        let writableDBPath = self.applicationDocumentsDirectoryFile()
        let cpath = writableDBPath.cStringUsingEncoding(NSUTF8StringEncoding)
        
        if sqlite3_open(cpath!, &db) != SQLITE_OK {
            sqlite3_close(db)
            assert(false, "数据库打开失败。")
        } else {
            let sql = "CREATE TABLE IF NOT EXISTS Note (cdate TEXT PRIMARY KEY, content TEXT)"
            let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            if (sqlite3_exec(db,cSql!, nil, nil, nil) != SQLITE_OK) {
                sqlite3_close(db)
                assert(false, "建表失败。")
            }
            sqlite3_close(db)
        }
    }
    
    func applicationDocumentsDirectoryFile() ->String {
        let  documentDirectory: NSArray = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let path = documentDirectory[0].stringByAppendingPathComponent(DBFILE_NAME) as String
        NSLog("path : %@", path)
        return path
    }
    
    
    //插入Note方法
    func create(model: Note) -> Int {
  
        let path = self.applicationDocumentsDirectoryFile()
        let cpath = path.cStringUsingEncoding(NSUTF8StringEncoding)
        
        if (sqlite3_open(cpath!, &db) != SQLITE_OK) {
            sqlite3_close(db)
            assert(false, "数据库打开失败。")
        } else {
            let sql = "INSERT OR REPLACE INTO note (cdate, content) VALUES (?,?)"
            let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            var statement:COpaquePointer = nil
            //预处理过程
            if sqlite3_prepare_v2(db, cSql!, -1, &statement, nil) == SQLITE_OK {
                
                let dateFormatter : NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let strDate = dateFormatter.stringFromDate(model.date)
                let cDate = strDate.cStringUsingEncoding(NSUTF8StringEncoding)
                
                let cContent = model.content.cStringUsingEncoding(NSUTF8StringEncoding)
                
                //绑定参数开始
                sqlite3_bind_text(statement, 1, cDate!, -1, nil)
                sqlite3_bind_text(statement, 2, cContent!, -1, nil)
                
                //执行插入
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    assert(false, "插入数据失败。")
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        
        return 0
    }
    
    //删除Note方法
    func remove(model: Note) -> Int {
        
        let path = self.applicationDocumentsDirectoryFile()
        let cpath = path.cStringUsingEncoding(NSUTF8StringEncoding)
        
        if (sqlite3_open(cpath!, &db) != SQLITE_OK) {
            sqlite3_close(db)
            assert(false, "数据库打开失败。")
        } else {
            let sql = "DELETE from note where cdate =?"
            let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            var statement:COpaquePointer = nil
            //预处理过程
            if sqlite3_prepare_v2(db, cSql!, -1, &statement, nil) == SQLITE_OK {
                
                let dateFormatter : NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let strDate = dateFormatter.stringFromDate(model.date)
                let cDate = strDate.cStringUsingEncoding(NSUTF8StringEncoding)
                
                //绑定参数开始
                sqlite3_bind_text(statement, 1, cDate!, -1, nil)
                
                //执行插入
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    assert(false, "删除数据失败。")
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        
        return 0
    }
    
    //修改Note方法
    func modify(model: Note) -> Int {
        
        let path = self.applicationDocumentsDirectoryFile()
        let cpath = path.cStringUsingEncoding(NSUTF8StringEncoding)
        
        if (sqlite3_open(cpath!, &db) != SQLITE_OK) {
            sqlite3_close(db)
            assert(false, "数据库打开失败。")
        } else {
            let sql = "UPDATE note set content=? where cdate =?"
            let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            var statement:COpaquePointer = nil
            //预处理过程
            if sqlite3_prepare_v2(db, cSql!, -1, &statement, nil) == SQLITE_OK {
                
                let dateFormatter : NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let strDate = dateFormatter.stringFromDate(model.date)
                let cDate = strDate.cStringUsingEncoding(NSUTF8StringEncoding)
                
                let cContent = model.content.cStringUsingEncoding(NSUTF8StringEncoding)
                
                //绑定参数开始
                sqlite3_bind_text(statement, 1, cContent!, -1, nil)
                sqlite3_bind_text(statement, 2, cDate!, -1, nil)
                
                //执行插入
                if (sqlite3_step(statement) != SQLITE_DONE) {
                    assert(false, "修改数据失败。")
                }
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        return 0
    }
    
    //查询所有数据方法
    func findAll() -> NSMutableArray {
        
        var listData = NSMutableArray()
        
        let path = self.applicationDocumentsDirectoryFile()
        let cpath = path.cStringUsingEncoding(NSUTF8StringEncoding)
        
        if (sqlite3_open(cpath!, &db) != SQLITE_OK) {
            sqlite3_close(db)
            assert(false, "数据库打开失败。")
        } else {
            let sql = "SELECT cdate,content FROM Note"
            let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            var statement:COpaquePointer = nil
            //预处理过程
            if sqlite3_prepare_v2(db, cSql!, -1, &statement, nil) == SQLITE_OK {
                
                let dateFormatter : NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                //执行
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    let bufDate = UnsafePointer<Int8>(sqlite3_column_text(statement, 0))
                    let strDate = String.fromCString(bufDate)!
                    let date : NSDate = dateFormatter.dateFromString(strDate)!

                    let bufContent = UnsafePointer<Int8>(sqlite3_column_text(statement, 1))
                    let strContent = String.fromCString(bufContent)!
                    
                    var note = Note(date: date, content:strContent)
                    
                    listData.addObject(note)
                }
                
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        
        return listData
    }
    
    //按照主键查询数据方法
    func findById(model: Note) -> Note? {
        
        let path = self.applicationDocumentsDirectoryFile()
        let cpath = path.cStringUsingEncoding(NSUTF8StringEncoding)
        
        if (sqlite3_open(cpath!, &db) != SQLITE_OK) {
            sqlite3_close(db)
            assert(false, "数据库打开失败。")
        } else {
            let sql = "SELECT cdate,content FROM Note where cdate =?"
            let cSql = sql.cStringUsingEncoding(NSUTF8StringEncoding)
            
            var statement:COpaquePointer = nil
            //预处理过程
            if sqlite3_prepare_v2(db, cSql!, -1, &statement, nil) == SQLITE_OK {
                
                let dateFormatter : NSDateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let strDate = dateFormatter.stringFromDate(model.date)
                let cDate = strDate.cStringUsingEncoding(NSUTF8StringEncoding)
                
                //绑定参数开始
                sqlite3_bind_text(statement, 1, cDate!, -1, nil)
                
                //执行
                if (sqlite3_step(statement) == SQLITE_ROW) {
                    
                    let bufDate = UnsafePointer<Int8>(sqlite3_column_text(statement, 0))
                    let strDate = String.fromCString(bufDate)!
                    let date : NSDate = dateFormatter.dateFromString(strDate)!
                    
                    let bufContent = UnsafePointer<Int8>(sqlite3_column_text(statement, 1))
                    let strContent = String.fromCString(bufContent)!
                    
                    var note = Note(date: date, content:strContent)
                    
                    sqlite3_finalize(statement)
                    sqlite3_close(db)
                    
                    return note
                }
                
            }
            sqlite3_finalize(statement)
            sqlite3_close(db)
        }
        return nil
    }
    
}
