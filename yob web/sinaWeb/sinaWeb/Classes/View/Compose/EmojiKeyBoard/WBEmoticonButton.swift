//
//  WBEmoticonButton.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/26.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBEmoticonButton: UIButton {

    var emoticon:WBEmoticonsModel?{
        didSet{
            
            
            guard let currentModel = emoticon else {
                return
            }
            self.isHidden = false
            
            if currentModel.type == "0"
            {
                //其他表情
                let image = UIImage(named: currentModel.path!, in: WBEmoticonsTool.sharedTool.mainEmoticonBundle, compatibleWith: nil)
                
                self.setImage(image, for: .normal)
                //防止复用
                self.setTitle(nil, for: .normal)
                
            }else
            {
                //emoji表情
                
                let title = (currentModel.code! as NSString).emoji()
                
                self.setTitle(title, for: .normal)
                //防止复用
                self.setImage(nil, for: .normal)
                
            }
            

        }
    }

}
