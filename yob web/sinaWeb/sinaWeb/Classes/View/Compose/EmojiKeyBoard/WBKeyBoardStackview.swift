//
//  WBKeyBoardStackview.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/24.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

enum EmojiKeyBoardBtnType:Int {
    case recent = 11
    case def = 12
    case emoji = 13
    case langXH = 14
}

class WBKeyBoardStackview: UIStackView {

    var EmojiBtnCallBack:((EmojiKeyBoardBtnType)->())?
    
    var preBtn:UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
        let btn = viewWithTag(12) as! UIButton
        
        btn.isSelected = true
        
        preBtn = btn
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI()
    {
        setEmojiBtn(imageName: "compose_emotion_table_mid", title: "最近", type: .recent)
        setEmojiBtn(imageName: "compose_emotion_table_mid", title: "默认", type: .def)
        setEmojiBtn(imageName: "compose_emotion_table_mid", title: "emoji", type: .emoji)
        setEmojiBtn(imageName: "compose_emotion_table_mid", title: "浪小花", type: .langXH)
        
        
        //接收通知改变按钮的选中状态
        NotificationCenter.default.addObserver(self, selector: #selector(changeBtnSelected(not:)), name: NSNotification.Name("sendSection"), object: nil)
    }
    
    func changeBtnSelected(not:NSNotification){
        
        let indexpath:IndexPath = not.object as! IndexPath
        
        let but = viewWithTag(indexpath.section + 11) as! UIButton
        
        if preBtn == but {
            return
        }
        preBtn?.isSelected = false
        but.isSelected = true
        preBtn = but
        
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func setEmojiBtn(imageName:String,title:String,type:EmojiKeyBoardBtnType)
    {
        let button = UIButton()
        
        button.tag = type.rawValue
    
        button.setBackgroundImage(UIImage(named:imageName + "_normal"), for: .normal)
        button.setBackgroundImage(UIImage(named:imageName + "_selected"), for: .selected)
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
     
        addArrangedSubview(button)
    }
    
    func clickBtn(btn:UIButton)
    {
        if preBtn == btn
        {
            return
        }
        preBtn?.isSelected = false
        
        btn.isSelected = true
        
        preBtn = btn
  
        let type = EmojiKeyBoardBtnType(rawValue: btn.tag)
        
        EmojiBtnCallBack?(type!)
    }
    
}
