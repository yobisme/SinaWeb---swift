//
//  WBTabBar.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/14.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBTabBar: UITabBar {

    var callBack:(()->())?
    
    
  //创建按钮
   private lazy var composeBut: UIButton = {
        let but = UIButton()
        
        but.setBackgroundImage(UIImage(named:"tabbar_compose_button"), for: .normal)
        
        but.setBackgroundImage(UIImage(named:"tabbar_compose_button_highlighted"), for: .highlighted)
    
        but.setImage(UIImage(named:"tabbar_compose_icon_add"), for: .normal)
        
        but.setImage(UIImage(named:"tabbar_compose_icon_add_highlighted"), for: .highlighted)
        
        but.sizeToFit()
    
        but.addTarget(self, action: #selector(clickAddBtn), for: .touchUpInside)
        
        return but
    }()
    
    //添加按钮
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(composeBut)
    }
    
     required init?(coder aDecoder: NSCoder) {
    
        super.init(coder: aDecoder)
        
         addSubview(composeBut)
        
    }
    
    //点击加号按钮
    @objc private func clickAddBtn()
    {
        callBack?()
    }
    
    
    //重新布局
    override func layoutSubviews() {
        super.layoutSubviews()
        
        composeBut.center.x = self.frame.size.width * 0.5
        
        composeBut.center.y = self.frame.size.height * 0.5
        
        let widthW = self.frame.size.width / 5
        
        var index = 0
        
        for subview in subviews
        {
            if subview .isKind(of: NSClassFromString("UITabBarButton")!) {
                
                subview.frame.origin.x = widthW * CGFloat(index)
                
                index += 1
                
                if index == 2{
                    index = 3
                }
            }
            
        }
        
        
    }
    
    

}
