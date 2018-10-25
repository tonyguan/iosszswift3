//
//  NSNumber+Message.swift
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

extension NSNumber {
    var errorMessage : String {
        var errorStr = ""
        switch (self) {
        case -7:
            errorStr = "没有数据。"
        case -6:
            errorStr = "日期没有输入。"
        case -5:
            errorStr = "内容没有输入。"
        case -4:
            errorStr = "ID没有输入。"
        case -3:
            errorStr = "据访问失败。"
        case -2:
            errorStr = "您的账号最多能插入10条数据。"
        case -1:
            errorStr = "用户不存在，请到http://www.51work6.com注册。"
        default:
            errorStr = ""
        }
        return errorStr
    }
}

