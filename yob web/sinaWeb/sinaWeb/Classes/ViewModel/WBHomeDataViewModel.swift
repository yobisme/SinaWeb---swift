//
//  WBHomeDataViewModel.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import SDWebImage
class WBHomeDataViewModel: NSObject {

    //var homeDataListArray = [WBHomeData]()
    
    var baseDataListArray = [WBBaseDataViewModel]()

    func loadHomeData(isUp:Bool,callBack:@escaping (Bool,String)->())
    {
        var maxId:Int64 = 0
        
        var sinceId:Int64 = 0
        
        if isUp {
            maxId = baseDataListArray.last?.homeData?.id ?? 0
            
            if maxId != 0 {
                maxId -= 1
            }
        }else
        {
            sinceId = baseDataListArray.first?.homeData?.id ?? 0
        }
        
        var messeage = "没有加载到最新的微博数据"
        
        let access_token = WBUserAccountViewModel.sharedViewModel.userAccount?.access_token
        
        WBNetworkTool.sharedTools.requestStatuesData(access_token: access_token!,maxId: maxId,sinceId: sinceId) { (response, error) in
            if error != nil
            {
                print(error!)
                return
            }else
            {
                //print(response)
                
                let dic = response as! [String:Any]
                
                let dataArray = dic["statuses"] as! [[String:Any]]
                
                let homeDataListArray = NSArray.yy_modelArray(with: WBHomeData.self, json: dataArray) as! [WBHomeData]
                
                var tempArray = [WBBaseDataViewModel]()
                                
                let group = DispatchGroup()
                
                for homeData in homeDataListArray
                {
                    let baseData = WBBaseDataViewModel()
                    
                    baseData.homeData = homeData
                    
                    tempArray.append(baseData)
                    
                    if homeData.pic_urls?.count == 1{
                        let imgStr = homeData.pic_urls?.first?.thumbnail_pic
                        
                        group.enter()
                        
                        SDWebImageManager.shared().loadImage(with: URL(string:imgStr!), options: [], progress: nil, completed: { (image, _, _, _, _, _) in
                            //print("单张图片下载完毕")
                            group.leave()
                        })
                        
                    }
                    
                    if homeData.retweeted_status?.pic_urls?.count == 1
                    {
                        let imgStr = homeData.retweeted_status?.pic_urls?.first?.thumbnail_pic
                        
                        group.enter()
                        
                        SDWebImageManager.shared().loadImage(with: URL(string:imgStr!), options: [], progress: nil, completed: { (image, _, _, _, _, _) in
                            //print("单张图片下载完毕")
                            group.leave()
                        })

                    }
                    
                }
       
                if isUp{
                    //上拉加载,添加新的数据
                    self.baseDataListArray.append(contentsOf: tempArray)
                }else
                {
                    //下拉加载插入最新数据
                    self.baseDataListArray.insert(contentsOf: tempArray, at: 0)
                }
                
                if tempArray.count > 0
                {
                    messeage = "加载了\(tempArray.count)条微博数据"
                }
                
                //self.baseDataListArray = tempArray

                group.notify(queue: DispatchQueue.main, execute: { 
                    
                    //print("所有单张照片下载完毕")
                    
                    callBack(true,messeage)
                })
            }
        }
    }

    
}
