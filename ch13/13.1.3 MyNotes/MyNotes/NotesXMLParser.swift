//
//  NotesXMLParser.swift
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

class NotesXMLParser: NSObject, NSXMLParserDelegate {
    
    //解析出的数据内部是字典类型
    private var notes : NSMutableArray!
    
    //当前标签的名字
    private var currentTagName: String!
    
    //开始解析
    func start() {
    
        let path = NSBundle.mainBundle().pathForResource("Notes", ofType: "xml")!
        let url = NSURL(fileURLWithPath: path)
        
        //开始解析XML
        var parser = NSXMLParser(contentsOfURL: url)!
        parser.delegate = self
        parser.parse()
        
        NSLog("解析开始...")
    }
    
    // MARK: --实现NSXMLParserDelegate委托方法
    //文档开始的时候触发
    func parserDidStartDocument(parser: NSXMLParser) {
        self.notes = NSMutableArray()
    }
    
    //文档出错的时候触发
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        NSLog("%@", parseError)
    }
   
    //遇到一个开始标签时候触发
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [NSObject : AnyObject]) {
        
        self.currentTagName = elementName
        if self.currentTagName == "Note" {
            let id = attributeDict["id"] as! NSString
            var dict = NSMutableDictionary()
            dict.setObject(id, forKey: "id")
            self.notes.addObject(dict)
        }
    }
    
    //遇到字符串时候触发
    func parser(parser: NSXMLParser, foundCharacters string: String?) {
        
        //替换回车符和空格
        let s1 = string!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if s1 == "" {
            return
        }
        
        var dict = self.notes.lastObject as! NSMutableDictionary
        if (self.currentTagName == "CDate") {
            dict.setObject(string!, forKey: "CDate")
        }

        if (self.currentTagName == "Content") {
            dict.setObject(string!, forKey: "Content")
        }
        
        if  (self.currentTagName == "UserID") {
            dict.setObject(string!, forKey: "UserID")
        }
    }
    
    
    //遇到结束标签时候出发
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        self.currentTagName = nil
    }
    
    //遇到文档结束时候触发
    func parserDidEndDocument(parser: NSXMLParser) {
        NSLog("解析完成...")
        NSNotificationCenter.defaultCenter().postNotificationName("reloadViewNotification", object: self.notes)
    }

}
