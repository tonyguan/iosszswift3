//
//  HotelBL.swift
//  BusinessLogicLayer
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

//定义BL关键字查询成功通知
let	BLQueryKeyFinishedNotification = "BLQueryKeyFinishedNotification"
//定义BL关键字查询失败通知
let BLQueryKeyFailedNotification = "BLQueryKeyFailedNotification"

//定义BL查询酒店成功通知
let BLQueryHotelFinishedNotification = "BLQueryHotelFinishedNotification"
//定义BL查询酒店失败通知
let BLQueryHotelFailedNotification = "BLQueryHotelFailedNotification"

let HOST_NAME = "jiagexian.com"
let KEY_QUERY_URL = "/ajaxplcheck.mobile?method=mobilesuggest&v=1&city=%@"
let HOTEL_QUERY_URL = "/hotelListForMobile.mobile?newSearch=1"

public class HotelBL: NSObject {
    
    class var sharedInstance: HotelBL {
        struct Static {
            static var instance: HotelBL?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            Static.instance = HotelBL()
        }
        return Static.instance!
    }
    
    //选择关键字
    public func selectKey(city:String!) {
        
        var strURL = NSString(format: KEY_QUERY_URL, city)
        strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var engine = MKNetworkEngine(hostName: HOST_NAME, customHeaderFields: nil)
        var op = engine.operationWithPath(strURL as String)
        
        op.addCompletionHandler({ (operation) -> Void in
            let data = operation.responseData()
            
            let resDict = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
            NSNotificationCenter.defaultCenter().postNotificationName(BLQueryKeyFinishedNotification, object:resDict)
            
        }, errorHandler: { (errorOp, err) -> Void in
            NSLog("MKNetwork请求错误 : %@", err.localizedDescription)
            NSNotificationCenter.defaultCenter().postNotificationName(BLQueryKeyFailedNotification, object:err)
        })
        engine .enqueueOperation(op)
    }
    
    //查询酒店
    public func queryHotel(keyInfo : [NSObject : AnyObject]) {
        var strURL = NSString(format: HOTEL_QUERY_URL)
        strURL = strURL.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        
        var params = [NSObject : AnyObject]()
        params["f_plcityid"] = keyInfo["Plcityid"]
        params["currentPage"] = keyInfo["currentPage"]
        params["q"] = keyInfo["key"]
      
        let price = keyInfo["Price"] as! String
        
        if price == "价格不限" {
            params["priceSlider_minSliderDisplay"] = "￥0"
            params["priceSlider_maxSliderDisplay"] = "￥3000+"
        } else {
            let set = NSCharacterSet(charactersInString: "--> ")
            let tempArray = price.componentsSeparatedByCharactersInSet(set)
            params["priceSlider_minSliderDisplay"] = tempArray[0]
            params["priceSlider_maxSliderDisplay"] = tempArray[3]
        }
        
        params["fromDate"] = keyInfo["Checkin"]
        params["toDate"] = keyInfo["Checkout"]
        
        var engine = MKNetworkEngine(hostName: HOST_NAME, customHeaderFields: nil)
        var op = engine.operationWithPath(strURL as String, params:params, httpMethod:"POST")
        
        op.addCompletionHandler({ (operation) -> Void in
            let data = operation.responseData()
            NSLog("查询酒店 = %@",operation.responseString())
            //声明可变数组
            var list = [AnyObject]()
            var error: NSError?
            
            let tbxml = TBXML(XMLData: data, error: &error)
            
            if error == nil {
                if let root = tbxml?.rootXMLElement {
                    let hotel_listElement = TBXML.childElementNamed("hotel_list", parentElement: root)
                    if hotel_listElement != nil {
                        
                        var hotelElement = TBXML.childElementNamed("hotel", parentElement: hotel_listElement)
                        
                        while hotelElement != nil {
                            
                            var dict = [NSObject : AnyObject]()
                            
                            //取id
                            let idElement = TBXML.childElementNamed("id", parentElement: hotelElement)
                            if idElement != nil {
                                dict["id"] = TBXML.textForElement(idElement)
                            }
                            //取name
                            let nameElement = TBXML.childElementNamed("name", parentElement: hotelElement)
                            if nameElement != nil {
                                dict["name"] = TBXML.textForElement(nameElement)
                            }
                            //取city
                            let cityElement = TBXML.childElementNamed("city", parentElement: hotelElement)
                            if cityElement != nil {
                                dict["city"] = TBXML.textForElement(cityElement)
                            }
                            //取address
                            let addressElement = TBXML.childElementNamed("address", parentElement: hotelElement)
                            if addressElement != nil {
                                dict["address"] = TBXML.textForElement(addressElement)
                            }
                            //取phone
                            let phoneElement = TBXML.childElementNamed("phone", parentElement: hotelElement)
                            if phoneElement != nil {
                                dict["phone"] = TBXML.textForElement(phoneElement)
                            }
                            //取lowprice
                            let lowpriceElement = TBXML.childElementNamed("lowprice", parentElement: hotelElement)
                            if lowpriceElement != nil {
                                dict["lowprice"] = BLHelp.prePrice(TBXML.textForElement(lowpriceElement))
                            }
                            //取grade
                            let gradeElement = TBXML.childElementNamed("grade", parentElement: hotelElement)
                            if gradeElement != nil {
                                dict["grade"] = BLHelp.preGrade(TBXML.textForElement(gradeElement))
                            }
                            //取description
                            let descriptionElement = TBXML.childElementNamed("description", parentElement: hotelElement)
                            if descriptionElement != nil {
                                dict["description"] = TBXML.textForElement(descriptionElement)
                            }
                            //取img
                            let imgElement = TBXML.childElementNamed("img", parentElement: hotelElement)
                            if imgElement != nil {
                                let src = TBXML.valueOfAttributeNamed("src", forElement: imgElement)
                                dict["img"] = src
                            }
                            
                            hotelElement = TBXML.nextSiblingNamed("hotel", searchFromElement: hotelElement)
                            
                            list.append(dict)
                            
                        }
                    }
                }
            }
            
            NSLog("解析完成...")
            NSNotificationCenter.defaultCenter().postNotificationName(BLQueryHotelFinishedNotification, object:list)
            
            }, errorHandler: { (errorOp, err) -> Void in
                NSLog("MKNetwork请求错误 : %@", err.localizedDescription)
                NSNotificationCenter.defaultCenter().postNotificationName(BLQueryHotelFailedNotification, object:err)
        })
        engine .enqueueOperation(op)
        
    }
}
