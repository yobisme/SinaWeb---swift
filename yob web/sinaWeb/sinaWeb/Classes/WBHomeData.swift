//
//  WBHomeData.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBHomeData: NSObject {
    //时间
    var created_at: Date?
    
    var id: Int64 = 0
    
    var text:String?
    
    var source:String?
    
    var user:WBUserModel?
    
    var retweeted_status:WBHomeData?
    
    //评论数
    var reposts_count:Int = 0
    //转发数
    var comments_count:Int = 0
    
    //赞
    var attitudes_count:Int = 0
    
    
    //pic_ids
    var pic_urls:[WBPicModel]?
    
    
    class func modelContainerPropertyGenericClass() -> [String: Any] {
        return [
            "pic_urls": WBPicModel.self
        ]
    }
}
