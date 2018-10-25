//
//  RoomBL.swift
//  JiaGeXian4iPhone
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

//定义BL查询酒店房间成功通知
let BLQueryRoomFinishedNotification	 = "BLQueryRoomFinishedNotification"
//定义BL查询酒店房间失败通知
let BLQueryRoomFailedNotification = "BLQueryRoomFailedNotification"

let ROOM_QUERY_URL = "/priceline/hotelroom/hotelroomcache.mobile"
//"/priceline/hotelroom/hotelroomqunar.mobile"

public class RoomBL: NSObject {

    class var sharedInstance: RoomBL {
        struct Static {
            static var instance: RoomBL?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = RoomBL()
        }
        return Static.instance!
    }
    
    //选择关键字
    public func queryRoom(keyInfo:[NSObject : AnyObject]) {
        
        var strURL = NSString(format: ROOM_QUERY_URL)
        strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var params = [NSObject : AnyObject]()
        params["supplierid"] = keyInfo["hotelId"]
        params["fromDate"] = keyInfo["Checkin"]
        params["toDate"] = keyInfo["Checkout"]
        
//        params["supplierid"] = "100194"
//        params["fromDate"] = "2015-05-10"
//        params["toDate"] = "2015-05-12"
        
        var engine = MKNetworkEngine(hostName: HOST_NAME, customHeaderFields: nil)
        var op = engine.operationWithPath(strURL as String, params:params, httpMethod:"POST")
        
        op.addCompletionHandler({ (operation) -> Void in
            let data = operation.responseData()
            
            //声明可变数组
            var list = [AnyObject]()
            var error: NSError?
            
            let tbxml = TBXML(XMLData: data, error: &error)
            
            if error == nil {
                if let root = tbxml?.rootXMLElement {
                    
                    let roomsElement = TBXML.childElementNamed("rooms", parentElement: root)
                    if roomsElement != nil {
                        
                        var roomElement = TBXML.childElementNamed("room", parentElement: roomsElement)
                        
                        while roomElement != nil {
                            
                            var dict = [NSObject : AnyObject]()

                            //取name
                            let name = TBXML.valueOfAttributeNamed("name", forElement: roomElement)
                            dict["name"] = name
                            
                            //取breakfast
                            let breakfast = TBXML.valueOfAttributeNamed("breakfast", forElement: roomElement)
                            dict["breakfast"] = BLHelp.preBreakfast(breakfast)
                            
                            //取bed
                            let bed = TBXML.valueOfAttributeNamed("bed", forElement: roomElement)
                            dict["bed"] = BLHelp.preBed(bed)
                            
                            //取broadband
                            let broadband = TBXML.valueOfAttributeNamed("broadband", forElement: roomElement)
                            dict["broadband"] = BLHelp.preBroadband(broadband)
                            
                            //取paymode
                            let paymode = TBXML.valueOfAttributeNamed("paymode", forElement: roomElement)
                            dict["paymode"] = BLHelp.prePaymode(paymode)
                            
                            //取frontprice
                            let frontprice = TBXML.valueOfAttributeNamed("frontprice", forElement: roomElement)
                            dict["frontprice"] = BLHelp.prePrice(frontprice)
                            
                            roomElement = TBXML.nextSiblingNamed("room", searchFromElement: roomElement)
                            
                            list.append(dict)
                            
                        }
                    }
                }
            }
            
            NSLog("解析完成...")
            NSNotificationCenter.defaultCenter().postNotificationName(BLQueryRoomFinishedNotification, object:list)
            
            }, errorHandler: { (errorOp, err) -> Void in
                NSLog("MKNetwork请求错误 : %@", err.localizedDescription)
                NSNotificationCenter.defaultCenter().postNotificationName(BLQueryRoomFailedNotification, object:err)
        })
        engine .enqueueOperation(op)
    }
    
}