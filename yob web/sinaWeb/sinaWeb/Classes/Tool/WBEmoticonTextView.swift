//
//  WBEmoticonTextView.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/16.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBEmoticonTextView: UITextView {

    var emoticon:WBEmoticonsModel?  = WBEmoticonsModel(){
        didSet{
            
            guard let currentModel = emoticon else{
                return
            }
            
            if currentModel.type == "0" {
                
                let preAtt = NSMutableAttributedString(attributedString: self.attributedText)
                
                let image = UIImage(named: (currentModel.path)!, in: WBEmoticonsTool.sharedTool.mainEmoticonBundle, compatibleWith: nil)
                //创建文本附件
                let attachment =  WBEmoticonAttachment()
                
                attachment.emoticonModel = currentModel
                
                attachment.image = image
                
                attachment.bounds = CGRect(x: 0, y: -4, width: (self.font?.lineHeight)!, height: (self.font?.lineHeight)!)
                
                let att = NSAttributedString(attachment: attachment)
                
                let range = self.selectedRange
                
                preAtt.replaceCharacters(in: range, with: att)
                
                preAtt.addAttributes([NSFontAttributeName:self.font!], range:NSMakeRange(0, preAtt.length))
                
                self.attributedText = preAtt
                
                //让光标显示在表情后面
                self.selectedRange = NSMakeRange(range.location + 1, 0)
                
                //手动发送通知和代理
                NotificationCenter.default.post(name: NSNotification.Name.UITextViewTextDidChange, object: nil)
                self.delegate?.textViewDidChange!(self)
                
                
            }else{
                let emoji = ((currentModel.code)! as NSString).emoji()
                
                self.insertText(emoji!)
            }

            
            
        }
    }

}
