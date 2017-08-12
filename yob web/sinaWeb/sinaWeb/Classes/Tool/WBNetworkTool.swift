//
//  WBNetworkTool.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/13.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import AFNetworking
//  网络请求类型
enum RequestType {
    // get请求
    case get
    // post请求
    case post
}

class WBNetworkTool: AFHTTPSessionManager {
    //  单例的全局访问点,在swift里面没有manager方法，可以使用init方法，一样的
    static let sharedTools: WBNetworkTool = {
        let tools = WBNetworkTool()
        //  mutating 这个关键字表示插入的数据影响set集合
        tools.responseSerializer.acceptableContentTypes?.insert("text/html")
        tools.responseSerializer.acceptableContentTypes?.insert("text/plain")
        return tools
    }()
    
    //  通用网络请求封装方法
    private func requestData(type: RequestType, urlStr: String, params: Any?, callBack: @escaping (Any?, Error?)->()) {
        if type == .get {
            get(urlStr, parameters: params, progress: nil, success: { (_, responseObject) in
                callBack(responseObject, nil)
            }, failure: { (_, error) in
                callBack(nil, error)
            })
        } else {
            post(urlStr, parameters: params, progress: nil, success: { (_, responseObject) in
                callBack(responseObject, nil)
            }, failure: { (_, error) in
                callBack(nil, error)
            })
        }
        
    }
    
    //获取令牌
    func requestAccessWithCode(params:[String:Any],callBack:@escaping (Any?)->())
    {
        let urlStr = "https://api.weibo.com/oauth2/access_token"
        
        requestData(type: .post, urlStr: urlStr, params: params) { (response, error) in
            if error != nil{
                print(error!)
            }else
            {
                print(response!)
                
                callBack(response)
            }
            
        }
    }
    
    //获取用户数据
    func requestUserInfo(access_token:String,uid:String,callBack:@escaping (Any?)->())
    {
        let urlStr = "https://api.weibo.com/2/users/show.json"
        
        let pamams = [
            "access_token":access_token,
            "uid":uid
        ]
        
        requestData(type: .get, urlStr: urlStr, params: pamams) { (response, error) in
            if error != nil
            {
                print(error!)
            }else
            {
                
                callBack(response)
            }
        }
    }
    
    //获取微博首页数据
    func requestStatuesData(access_token:String,maxId:Int64 = 0,sinceId:Int64 = 0,callBack:@escaping (Any?, Error?) -> ())
    {
        let urlStr = "https://api.weibo.com/2/statuses/home_timeline.json"
        
        let params:[String : Any] = [
            "access_token":access_token,
            "max_id":maxId,
            "since_id":sinceId
        ]
        requestData(type: .get, urlStr: urlStr, params: params, callBack: callBack)
    }
    
    // 发送单纯文字的微博信息
    func sendWebDataWithText(access_token:String,text:String,callBack:@escaping (Any?, Error?) -> ())
    {
        let urlStr = "https://api.weibo.com/2/statuses/update.json"
        
        let params:[String:Any] = [
            "access_token":access_token,
            "status":text
        ]
        
        requestData(type: .post, urlStr: urlStr, params: params, callBack: callBack)
    }
    
    //发送含图片的微博信息
    func sendWebDataWithTextAndPic(access_token:String,text:String,pic:UIImage,callBack:@escaping (Any?, Error?) -> ()){
        
        let urlStr = "https://upload.api.weibo.com/2/statuses/upload.json"
        
        let params:[String:Any] = [
            "access_token":access_token,
            "status":text
        ]
        
        //转成二进制  -->>很重要
        let imageData = UIImageJPEGRepresentation(pic, 0.5)
        
        post(urlStr, parameters: params, constructingBodyWith: { (data) in
            
            data.appendPart(withFileData: imageData!, name: "pic", fileName: "image", mimeType: "image/JPEG")
            
        }, progress: nil, success: { (response, error) in
            callBack(response,nil)
            
        }) { (nil, error) in
            callBack(nil,error)
        }
        
    }
    
    
    
}
