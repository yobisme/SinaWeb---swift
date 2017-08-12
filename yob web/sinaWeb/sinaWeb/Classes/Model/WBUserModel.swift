//
//  WBUserModel.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBUserModel: NSObject {
    var screen_name:String?
    var profile_image_url:String?
    //认证
    var verified_type:Int = -1
    var id:Int64 = 0
    //vip
    var mbrank:Int = 0
}
