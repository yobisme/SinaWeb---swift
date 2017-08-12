//
//  WBUserAccountViewModel.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/17.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBUserAccountViewModel: NSObject {

    
    //是否登录的标记
    var isLogin:Bool
    { 
    // access_token有值,并且没有过期,登录标记为true
        if userAccount?.access_token != nil && userAccount?.expires_date?.compare(Date()) == .orderedDescending
        {
            return true
   
        }else
        {
            return false
        }
    }

    static let sharedViewModel:WBUserAccountViewModel = WBUserAccountViewModel()
    
    var userAccount:WBUserAccountModel?
    
    private override init()
    {
        super.init()
        
        userAccount = WBUserAccountModel.decoder()
        
    }

    func getAccess_tokenAndUserInfo(params:Any,callBack:@escaping (Bool)->())
    {
        WBNetworkTool.sharedTools.requestAccessWithCode(params: params as! [String : Any], callBack: { (response) in
            
            let dic = response as! [String:Any]
            
            let userAccount:WBUserAccountModel = WBUserAccountModel(dic: dic)
            
            WBNetworkTool.sharedTools.requestUserInfo(access_token: userAccount.access_token!, uid: String(userAccount.uid), callBack: { (response) in
            
                let dic = response as! [String:Any]
                
                let name = dic["name"] as? String
                
                let avatar_large = dic["avatar_large"] as? String
                
                userAccount.name = name
                
                userAccount.avatar_large = avatar_large
                
                userAccount.encode()
                
                self.userAccount = userAccount
                
                //print(self.userAccount?.name)
                
                callBack(true)
            })
            
        })

    }
    
}
