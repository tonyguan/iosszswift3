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

protocol NoteBLDelegate {
    
    //查询所有数据方法 成功
    func findAllNotesFinished(list : NSMutableArray)
    
    //查询所有数据方法 失败
    func findAllNotesFailed(error : NSError)
    
    //插入Note方法 成功
    func createNoteFinished()
    
    //插入Note方法 失败
    func createNoteFailed(error : NSError)
    
    //修改Note方法 成功
    func modifyNoteFinished()
    
    //修改Note方法 失败
    func modifyNoteFailed(error : NSError)
    
    //删除Note方法 成功
    func removeNoteFinished()
    
    //删除Note方法 失败
    func removeNoteFailed(error : NSError)
    
}

class NoteBL : NSObject, NoteDAODelegate {
    
    var delegate: NoteBLDelegate!
    
    //插入Note方法
    func createNote(model: Note) {
        var dao:NoteDAO = NoteDAO.sharedInstance
        dao.delegate = self
        dao.create(model)
    }
    
    //修改Note方法
    func modifyNote(model: Note) {
        var dao:NoteDAO = NoteDAO.sharedInstance
        dao.delegate = self
        dao.modify(model)
    }
    
    
    //删除Note方法
    func removeNote(model: Note) {
        var dao:NoteDAO = NoteDAO.sharedInstance
        dao.delegate = self
        dao.remove(model)
    }
    
    //查询所用数据方法
    func findAllNotes() {
        var dao:NoteDAO = NoteDAO.sharedInstance
        dao.delegate = self
        dao.findAll()
    }
    
    //MARK: --NoteDAODelegate 委托方法
    //查询所有数据方法 成功
    func findAllFinished(list: NSMutableArray) {
        self.delegate.findAllNotesFinished(list)
    }
    
    //查询所有数据方法 失败
    func findAllFailed(error : NSError) {
        self.delegate.findAllNotesFailed(error)
    }
    
    //插入Note方法 成功
    func createFinished() {
        self.delegate.createNoteFinished()
    }
    
    //插入Note方法 失败
    func createFailed(error : NSError) {
        self.delegate.createNoteFailed(error)
    }
    
    //删除Note方法 成功
    func removeFinished() {
        self.delegate.removeNoteFinished()
    }
    //删除Note方法 失败
    func removeFailed(error : NSError) {
        self.delegate.removeNoteFailed(error)
    }
    
    //修改Note方法 成功
    func modifyFinished(){
        self.delegate.modifyNoteFinished()
    }
    //修改Note方法 失败
    func modifyFailed(error : NSError) {
        self.delegate.modifyNoteFailed(error)
    }
    
    //按照主键查询数据方法 成功
    func findByIdFinished(model : Note) {}
    
    //按照主键查询数据方法 失败
    func findByIdFailed(error : NSError) {}
    
    
}
