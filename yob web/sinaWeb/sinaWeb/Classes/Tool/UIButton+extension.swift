//
//  UIButton+extension.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/14.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

extension UIBarButtonItem
{
    
    convenience init(target: Any?,title: String,action: Selector,imageName: String? = nil)
    {
        self.init()
        
        let but = UIButton()
        
        but.setTitleColor(UIColor.darkGray, for: .normal)
        
        but.setTitleColor(UIColor.orange, for: .highlighted)
        
        but.setTitle(title, for: .normal)
        
        but.addTarget(target, action: action, for: .touchUpInside)
        
        but.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        
        if imageName != nil {
            but.setImage(UIImage(named:imageName!), for: .normal)
        }
        
        but.sizeToFit()
        
        self.customView = but
    }
    
    
    
}
