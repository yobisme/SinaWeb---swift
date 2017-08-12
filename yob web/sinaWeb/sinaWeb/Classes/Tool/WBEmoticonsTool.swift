//
//  WBEmoticonsTool.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/14.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import YYModel

let maxNum = 20

let recentEmoticonSavePath = (NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).last! as NSString).appendingPathComponent("recentEmoticon.plist")

class WBEmoticonsTool: NSObject {
    
    static let sharedTool:WBEmoticonsTool = WBEmoticonsTool()
    
    // 获取bundle
    var mainEmoticonBundle:Bundle = {
       
         let path = Bundle.main.path(forResource: "Emoticons.bundle", ofType: nil)!
        
        let bundle = Bundle(path: path)!
        
        return bundle
    }()
    
    
    //默认表情
    lazy var defaultEmoticonArray:[WBEmoticonsModel] = {
       return self.loadEveryEmotiocnsData(folderName: "default", fileName: "info.plist")
    }()
    //分组完的默认表情
    lazy var defaultEmoticon:[[WBEmoticonsModel]] = {
       return self.subSection(array: self.defaultEmoticonArray)
    }()
    //emoji表情
    lazy var emojiEmoticonArray:[WBEmoticonsModel] = {
        return self.loadEveryEmotiocnsData(folderName: "emoji", fileName: "info.plist")
    }()
    //分组完的emoji表情
    lazy var emojiEmoticon:[[WBEmoticonsModel]] = {
        return self.subSection(array: self.emojiEmoticonArray)
    }()
    //浪小花表情
    lazy var lxhEmoticonArray:[WBEmoticonsModel] = {
        return self.loadEveryEmotiocnsData(folderName: "lxh", fileName: "info.plist")
    }()
    //分组完的浪小花表情
    lazy var lxhEmoticon:[[WBEmoticonsModel]] = {
        return self.subSection(array: self.lxhEmoticonArray)
    }()
    // 最近表情
    lazy var recentEmoticon:[WBEmoticonsModel] = {
        if let loadDataArray:[WBEmoticonsModel] = self.unCodeRecentEmoticon()
        {
            
            return loadDataArray
        }
        
        let recent = [WBEmoticonsModel]()
        return recent
    }()
    //合成整组
    lazy var allDataArray:[[[WBEmoticonsModel]]] = {
         print(self.recentEmoticon.count)
        return [
            [self.recentEmoticon],
            self.defaultEmoticon,
            self.emojiEmoticon,
            self.lxhEmoticon
        ]
    }()
    //获取每组表情
    func loadEveryEmotiocnsData(folderName:String,fileName:String)->[WBEmoticonsModel]
    {
        let path = mainEmoticonBundle.path(forResource: "\(folderName)/\(fileName)", ofType: nil)
        
        let array = NSArray(contentsOfFile: path!)!
        
        let emoticonsArray = NSArray.yy_modelArray(with: WBEmoticonsModel.self, json: array) as! [WBEmoticonsModel]
        
        for model in emoticonsArray
        {
            if model.type == "0"
            {
                model.path = folderName + "/" + model.png!
            }
        }
        
        return emoticonsArray
    }
    
    //将每组分成多组
    func subSection(array:[WBEmoticonsModel])->([[WBEmoticonsModel]])
    {
        let section = (array.count - 1) / maxNum + 1
        
        var allArray:[[WBEmoticonsModel]] = [[WBEmoticonsModel]]()
        
        for i in 0..<section
        {
            let loc = i * maxNum
            
            var len = 20
            
            if loc + len > array.count {
                len = array.count - loc
            }
 
            let subArray = (array as NSArray).subarray(with: NSRange(location: loc, length: len)) as! [WBEmoticonsModel]
            
            allArray.append(subArray)
        }
        
        return allArray
        
    }
    
    
    func saveEmoticonWith(emoticonModel:WBEmoticonsModel,callBack:()->()){
        // 判断是否已经有表情
        for (i,emoticon) in recentEmoticon.enumerated()
        {
            if emoticon.type == "1" {
                // emoji表情
                if emoticon.code == emoticonModel.code {
                    //已经存在了
                    recentEmoticon.remove(at: i)
                    
                    break
                }
            }else{
                
                if emoticon.png == emoticonModel.png{
                    //已经存在了
                    recentEmoticon.remove(at: i)
                    
                     break
                }
            }
        }
        
        if recentEmoticon.count == 20 {
            recentEmoticon.remove(at: 19)
        }
        
        recentEmoticon.insert(emoticonModel, at: 0)
        
        print(recentEmoticon.count)
        //重新赋值
        self.allDataArray[0][0] = recentEmoticon
        
        //归档
        NSKeyedArchiver.archiveRootObject(recentEmoticon, toFile: recentEmoticonSavePath)
        
        
        //刷新数据
        callBack()
        
    }
    //解档
    func unCodeRecentEmoticon()->([WBEmoticonsModel]?){
        
        return NSKeyedUnarchiver.unarchiveObject(withFile: recentEmoticonSavePath) as? ([WBEmoticonsModel])
    }
    
    
    // 根据表情描述找相应的模型
    func searchModelByChs(chs:String)->(WBEmoticonsModel?){
        for model in defaultEmoticonArray{
            if model.chs == chs {
                return model
            }
        }
        
        for model in lxhEmoticonArray{
            if model.chs == chs {
                return model
            }
        }
        return nil
    }

}
