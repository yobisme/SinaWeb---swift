//
//  WBBaseDataViewModel.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import YYText

class WBBaseDataViewModel: NSObject {

    var homeData:WBHomeData?
    {
        didSet{
            
            if let type:Int = homeData?.user?.verified_type,type >= 0
            {
                switch type {
                case 0:
                    verifiedImg = "avatar_vip"
                case 2,3,5:
                    verifiedImg = "avatar_enterprise_vip"
                case 220:
                    verifiedImg = "avatar_grassroot"
                default:
                    verifiedImg = nil
                }
            }
            
            //原创微博的富文本
            originaViewText = getWebTextAttributedString(text: (homeData?.text)!, font:UIFont.systemFont(ofSize: 14),color:UIColor.darkGray)
            
            
            
            
            if  let mbrankS = homeData?.user?.mbrank,mbrankS >= 1 && mbrankS <= 6 {
               mbrank  = UIImage(named: "common_icon_membership_level\(mbrankS)")
            }
            
            // 转发微博的富文本
            if let reweetText = homeData?.retweeted_status?.text{
                
                retweetedStr = "@\((homeData?.retweeted_status?.user?.screen_name)!): \(reweetText)"
                reweetedViewText = getWebTextAttributedString(text: retweetedStr!, font: UIFont.systemFont(ofSize: 13), color: UIColor.lightGray)
                
            }
            
            
        //来源
            if let startR = homeData?.source?.range(of: "\">"),let endR = homeData?.source?.range(of: "</"){
                
                let startIndex = startR.upperBound
                
                let endIndex = endR.lowerBound

                souceText = homeData?.source?.substring(with: startIndex..<endIndex)
            }
            
            repostsCount = self.abc(count: homeData?.reposts_count,type: 1)
            commentsCount = self.abc(count: homeData?.comments_count,type: 3)
            attitudescount = self.abc(count: homeData?.attitudes_count,type: 5)
            //print(homeData?.created_at)
        }
    }
    
    var verifiedImg:String?
    var mbrank:UIImage?
    //评论转发赞
    var repostsCount:String?
    var commentsCount:String?
    var attitudescount:String?
    //来源
    var souceText:String?
    //转发微博的内容
    var retweetedStr:String?
    //原创微博富文本
    var originaViewText:NSAttributedString?
    //转发微博富文本
    var reweetedViewText:NSAttributedString?
    
    func getWebTextAttributedString(text:String,font:UIFont,color:UIColor)->NSAttributedString{
        
        let textAttri = NSMutableAttributedString(string: text)
        
        let regular = try! NSRegularExpression(pattern: "\\[\\w+\\]", options: [])

        let textCheckingResult = regular.matches(in: text, options: [], range: NSMakeRange(0, textAttri.length))
        
        for result in textCheckingResult.reversed()
        {
            
            let range = result.range
            
            let chs = (text as NSString).substring(with: range)
            
            if let model = WBEmoticonsTool.sharedTool.searchModelByChs(chs: chs)
            {
                let image = UIImage(named: model.path!, in: WBEmoticonsTool.sharedTool.mainEmoticonBundle, compatibleWith: nil)!
                
                let att = NSAttributedString.yy_attachmentString(withEmojiImage: image, fontSize: CTFontGetSize(font))!
    
                //创建文本附件
//                let attachment =  WBEmoticonAttachment()
//                
//                attachment.emoticonModel = model
//                
//                attachment.image = image
//                
//                attachment.bounds = CGRect(x: 0, y: -4, width: font.lineHeight, height: font.lineHeight)
//                
//                let att = NSAttributedString(attachment: attachment)
                
                textAttri.replaceCharacters(in: range, with: att)
            }
 
        }
        
        textAttri.addAttributes([NSFontAttributeName:font,NSForegroundColorAttributeName:color], range: NSMakeRange(0, textAttri.length))
        
        //setHighlitedText(patten: "@[^\\s]+", att: textAttri)
        setHighlitedText(patten: "@[^:]+", att: textAttri)
        setHighlitedText(patten: "#[^#]+#", att: textAttri)
        setHighlitedText(patten: "http[s]?://[^\\s\\u4e00-\\u9fa5]+", att: textAttri)
        
        return textAttri
    }
    
    func setHighlitedText(patten:String,att:NSMutableAttributedString){
        
        let regular = try! NSRegularExpression(pattern: patten, options: [])
        
        let textCheckingResult = regular.matches(in: att.string, options: [], range: NSMakeRange(0, att.length))
        
        for result in textCheckingResult{
            let range = result.range
            let color = UIColor(red: 80 / 255, green: 125 / 255, blue: 215 / 255, alpha: 1)
            att.addAttributes([NSForegroundColorAttributeName:color], range: range)
            let highlightedText = YYTextHighlight()
            let bgColor = UIColor(red: 177 / 255, green: 215 / 255, blue: 255 / 255, alpha: 1)
            let boder = YYTextBorder(fill: bgColor, cornerRadius: 3)
            boder.insets = UIEdgeInsetsMake(1, 0, 0, 0)
            highlightedText.setBackgroundBorder(boder)
            att.yy_setTextHighlight(highlightedText, range: range)
            
        }
        
        
    }
    
    //时间
    var creatAt:String?
    {
        get{
            guard let creatTime = homeData?.created_at else {
                return nil
            }
            
            let date = DateFormatter()
            date.dateFormat = "yyyy"
            
            let currentYear = date.string(from: Date())
            let creatYear = date.string(from: creatTime)
            
            if currentYear != creatYear {
                //不是今年
                date.dateFormat = "yyyy-MM-dd HH:mm"
            }else
            {
                let calendar = Calendar.current
                
                if calendar.isDateInToday(creatTime){
                    //今天
                    
                    let num = abs(creatTime.timeIntervalSinceNow)
                    
                    if num < 60 {
                        return "刚刚"
                    }else if num < 3600{
                        return "\(Int(num/60))分钟之前"
                    }else
                    {
                        return "\(Int(num/3600))小时之前"
                    }
                    
                }else if calendar.isDateInYesterday(creatTime) {
                    //昨天
                    date.dateFormat = "昨天 HH:mm"
                }else
                {
                    //其他
                    date.dateFormat = "MM-dd HH:mm"
                }
            }
            
           return date.string(from: creatTime)
            
        }
        
       
    }
    
    func abc(count:Int?,type:Int)->(String)
    {
        var str:String?
        switch type {
        case 1:
            str = "转发"
        case 3:
            str = "评论"
        default:
             str = "赞"
    }
        if count == 0 {
            return str!
        }else if (count)! < 10000{
            return "\((count)!)"
        }else if  count! % 10000 < 1000{
            return "\(Int((count)! / 10000))万"
        }else{
            let wan = count! / 10000
            let qian = count! / 1000 % 10
            return "\(wan).\(qian)万"
        }

    }
}
