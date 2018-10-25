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
    //保存数据列表
    var listData: NSMutableArray!
    
    class var sharedInstance: NoteDAO {
        struct Static {
            static var instance: NoteDAO?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            
            Static.instance = NoteDAO()
            
            //添加一些测试数据
            var dateFormatter : NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            var date1: NSDate = dateFormatter.dateFromString("2015-01-01 16:01:03")!
            var note1: Note = Note(date:date1, content: "Welcome to MyNote.")

            var date2: NSDate = dateFormatter.dateFromString("2015-01-02 8:01:03")!
            var note2: Note = Note(date:date2, content: "欢迎使用MyNote。")
            
            Static.instance?.listData = NSMutableArray()
            Static.instance?.listData.addObject(note1)
            Static.instance?.listData.addObject(note2)
            
        }
        return Static.instance!
    }
    
    
    //插入Note方法
    func create(model: Note) -> Int {
        self.listData.addObject(model)
        return 0
    }
    
    //删除Note方法
    func remove(model: Note) -> Int {
        for note in self.listData {
            var note2 = note as! Note
            //比较日期主键是否相等
            if note2.date == model.date {
                self.listData.removeObject(note2)
                break
            }
        }
        return 0
    }
    
    //修改Note方法
    func modify(model: Note) -> Int {
        for note in self.listData {
            var note2 = note as! Note
            //比较日期主键是否相等
            if note2.date == model.date {
                note2.content = model.content
                break
            }
        }
        return 0
    }
    
    //查询所有数据方法
    func findAll() -> NSMutableArray {
        return self.listData
    }
    
    //修改Note方法
    func findById(model: Note) -> Note? {
        for note in self.listData {
            var note2 = note as! Note
            //比较日期主键是否相等
            if note2.date == model.date {
                return note2
            }
        }
        return nil
    }
    
}
