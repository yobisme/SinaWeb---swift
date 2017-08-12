//
//  WBComposeButton.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/21.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBComposeButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView?.contentMode = .center
        titleLabel?.textAlignment = .center
        
        titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        titleLabel?.textColor = UIColor.orange
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        bounds.size = CGSize(width: 80, height: 110)
        
        imageView?.frame.origin.y = 0
        imageView?.frame.size.width = self.bounds.size.width
        imageView?.frame.size.height = self.bounds.size.width
        
        titleLabel?.frame.origin.x = 0
        titleLabel?.frame.origin.y = self.bounds.size.width
        titleLabel?.frame.size.width = self.bounds.size.width
        titleLabel?.frame.size.height = 30

    }
    
  
    

}
