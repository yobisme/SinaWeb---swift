//
//  WBToolBarStackView.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/23.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

enum ToolBarStackViewBtnType: Int{
    // 图片
    case picture = 0
    //  @
    case mention = 1
    //  #
    case trend = 2
    //  表情
    case emoticon = 3
    //  加号
    case add = 4
}

class WBToolBarStackView: UIStackView {

    
    var callBack:((ToolBarStackViewBtnType)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setupUI()
    {
        addButtonWithImageAndType(image: "compose_toolbar_picture", type: .picture)
        addButtonWithImageAndType(image: "compose_mentionbutton_background", type: .mention)
        addButtonWithImageAndType(image: "compose_trendbutton_background", type: .trend)
        addButtonWithImageAndType(image: "compose_emoticonbutton_background", type: .emoticon)
        addButtonWithImageAndType(image: "compose_add_background", type: .add)

    }
    
    func addButtonWithImageAndType(image:String,type:ToolBarStackViewBtnType)
    {
        let btn = UIButton()
        
        btn.tag = type.rawValue
        
        btn.setImage(UIImage(named: image), for: .normal)
        btn.setImage(UIImage(named: image + "_highlighted"), for: .highlighted)
        btn.setBackgroundImage(UIImage(named: "compose_toolbar_background"), for: .normal)
      
        btn.adjustsImageWhenHighlighted = false
        
        btn.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
        
        addArrangedSubview(btn)
    }
    
    
    func clickBtn(btn:UIButton)
    {
        let type = ToolBarStackViewBtnType(rawValue: btn.tag)!
        
        callBack?(type)
    }
}
    
