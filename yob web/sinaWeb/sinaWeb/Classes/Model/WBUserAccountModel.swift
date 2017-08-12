//
//  WBUserAccountModel.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/17.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

let encodePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("encodeData.plist")

class WBUserAccountModel: NSObject,NSCoding {

    
    var access_token:String?
    var expires_date:Date?
    var expires_in:Int64 = 0{
        didSet{
            expires_date = Date().addingTimeInterval(TimeInterval(expires_in))
        }
    }
    var uid:Int64 = 0
    
    var name:String?
    
    var avatar_large:String?

    init(dic:[String:Any])
    {
        super.init()
        
        setValuesForKeys(dic)
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {
        
    }
    
    //归档
    func encode(with aCoder: NSCoder) {
        aCoder.encode(access_token, forKey: "access_token")
        aCoder.encode(avatar_large, forKey: "avatar_large")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(expires_date, forKey: "expires_date")
        aCoder.encode(uid, forKey: "uid")

    }
    //解档
    required init?(coder aDecoder: NSCoder) {
        access_token = aDecoder.decodeObject(forKey: "access_token") as? String
        avatar_large = aDecoder.decodeObject(forKey: "avatar_large") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        expires_date = aDecoder.decodeObject(forKey: "expires_date") as? Date
        uid = aDecoder.decodeInt64(forKey: "uid")
    }
    
    
    func encode()
    {
        NSKeyedArchiver.archiveRootObject(self, toFile: encodePath)
    }
    class func decoder()->WBUserAccountModel?
    {
        return (NSKeyedUnarchiver.unarchiveObject(withFile: encodePath) as? (WBUserAccountModel))
   
    }
    
}



