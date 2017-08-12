//
//  WBEmoticonsModel.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/24.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBEmoticonsModel: NSObject,NSCoding {
    var chs:String?
    var code:String?
    var type:String?
    var png:String?
    var path:String?
    
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
       
        chs = aDecoder.decodeObject(forKey: "chs") as? String
        code = aDecoder.decodeObject(forKey: "code") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        png = aDecoder.decodeObject(forKey: "png") as? String
        path = aDecoder.decodeObject(forKey: "path") as? String
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(code, forKey: "code")
        aCoder.encode(chs, forKey: "chs")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(png, forKey: "png")
        aCoder.encode(path, forKey: "path")
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
}
