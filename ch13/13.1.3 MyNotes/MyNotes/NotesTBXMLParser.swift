//
//  NotesTBXMLParser.swift
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

class NotesTBXMLParser: NSObject {
    
    //解析出的数据内部是字典类型
    private var notes : NSMutableArray!
    
    //开始解析
    func start() {
        
        self.notes = NSMutableArray()
        
        var tbxml = TBXML(XMLFile: "Notes.xml", error:nil)
        
        var root = tbxml.rootXMLElement
        
        if root != nil {

            var noteElement = TBXML.childElementNamed("Note",  parentElement: root)
            
            while noteElement != nil {
                
                var dict = NSMutableDictionary()
                
                var CDateElement = TBXML.childElementNamed("CDate" , parentElement: noteElement)
                if  CDateElement != nil {
                    var CDate = TBXML.textForElement(CDateElement)
                    dict.setValue(CDate, forKey: "CDate")
                }
            
                var ContentElement = TBXML.childElementNamed("Content" , parentElement: noteElement)
                if  ContentElement != nil {
                    var Content = TBXML.textForElement(ContentElement)
                    dict.setValue(Content, forKey: "Content")
                }
                
                var UserIDElement = TBXML.childElementNamed("UserID" , parentElement: noteElement)
                if  UserIDElement != nil {
                    var UserID = TBXML.textForElement(UserIDElement)
                    dict.setValue(UserID, forKey: "UserID")
                }
                
                var id = TBXML.valueOfAttributeNamed("id", forElement: noteElement)
                dict.setValue(id, forKey: "id")
                
                self.notes.addObject(dict)
                
                noteElement = TBXML.nextSiblingNamed("Note", searchFromElement: noteElement)
                
            }
        }

        NSLog("解析完成...")
        NSNotificationCenter.defaultCenter().postNotificationName("reloadViewNotification", object: self.notes)
        
        self.notes = nil
    }
    
}
