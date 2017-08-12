//
//  WBTextView.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/23.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit



class WBTextView: WBEmoticonTextView {

    var images:[UIImage] = [UIImage]()
    
    
    
    var placeHoldarLabel:UILabel = {
       let label = UILabel()
        label.text = "请输入想说的话...."
        label.textColor = UIColor.lightGray
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        setupUI()
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
        
       
        addSubview(placeHoldarLabel)
                
        placeHoldarLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.left.equalTo(self).offset(5)
            make.width.equalTo(UIScreen.main.bounds.size.width - 10)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: nil)
        
    }
    
    func textDidChange()
    {
        placeHoldarLabel.isHidden = self.hasText
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
