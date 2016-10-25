//
//  IngreRecommend.swift
//  TestKitchen
//
//  Created by qianfeng on 16/10/24.
//  Copyright © 2016年 zhb. All rights reserved.
//

import UIKit
import SwiftyJSON

class IngreRecommend: NSObject {
    var code: NSNumber?
    var data: IngreRecommendData?
    var msg: NSNumber?
    var timestamp: NSNumber?
    var version: String?
    
    //解析
    class func parseData(data: NSData) -> IngreRecommend {
        let json = JSON(data: data)
        let model = IngreRecommend()
        model.code = json["code"].number
        model.data = IngreRecommendData.parseModel(json["data"])
        model.msg = json["msg"].number
        model.timestamp = json["timestamp"].number
        model.version = json["version"].string
        return model
    }
}

class IngreRecommendData: NSObject {
    var banner: Array<IngreRecommendBanner>?
    var widgetList: Array<IngreRecommendWidget>?
    
    //解析
    class func parseModel(json: JSON) -> IngreRecommendData {
        let model = IngreRecommendData()
        
        var tmpBannerArray = Array<IngreRecommendBanner>()
        for (_, subjson) in json["banner"] {
            tmpBannerArray.append(IngreRecommendBanner.parseModel(subjson))
        }
        model.banner = tmpBannerArray
        
        var tmpWidgetListArray = Array<IngreRecommendWidget>()
        for (_, subjson) in json["widgetList"] {
            tmpWidgetListArray.append(IngreRecommendWidget.parseModel(subjson))
        }
        model.widgetList = tmpWidgetListArray
        return model
    }
}

class IngreRecommendBanner: NSObject {
    var banner_id: NSNumber?
    var banner_link: String?
    var banner_picture: String?
    var banner_title: String?
    var is_link: NSNumber?
    var refer_key: NSNumber?
    var type_id: NSNumber?
    
    //解析
    class func parseModel(json: JSON) -> IngreRecommendBanner {
        let model = IngreRecommendBanner()
        model.banner_id = json["banner_id"].number
        model.banner_link = json["banner_link"].string
        model.banner_picture = json["banner_picture"].string
        model.banner_title = json["banner_title"].string
        model.is_link = json["is_link"].number
        model.refer_key = json["refer_key"].number
        model.type_id = json["type_id"].number
        return model
    }
}

class IngreRecommendWidget: NSObject {
    var desc: String?
    var title: String?
    var title_link: String?
    var widget_data: Array<IngreRecommendWidgetData>?
    var widget_id: NSNumber?
    var widget_type: NSNumber?
    
    class func parseModel(json: JSON) -> IngreRecommendWidget{
        let model  = IngreRecommendWidget()
        model.desc = json["desc"].string
        model.title = json["title"].string
        model.title_link = json["title_link"].string
        var tmpWidgetDataArray = Array<IngreRecommendWidgetData>()
        for (_,subjson) in json["widget_data"] {
            //循环调用遍历数组
            tmpWidgetDataArray.append(IngreRecommendWidgetData.parseModel(subjson))
        }
        model.widget_data = tmpWidgetDataArray
        model.widget_id = json["widget_id"].number
        model.widget_type = json["widget_type"].number
        return model
    }
}

class IngreRecommendWidgetData: NSObject {
    var content: String?
    var id: NSNumber?
    var link: String?
    var type: String?
    
    class func parseModel(json: JSON) -> IngreRecommendWidgetData {
        let model = IngreRecommendWidgetData()
        model.content = json["content"].string
        model.id = json["id"].number
        model.link = json["link"].string
        model.type = json["type"].string
        return model
    }
}
