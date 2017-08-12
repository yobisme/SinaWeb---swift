//
//  WBTabtoolButton.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

//转发 评论  赞
class WBTabtoolButton: UIView {

    var plBtn:UIButton?
    var zfBtn:UIButton?
    var zanBtn:UIButton?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    var baseData:WBBaseDataViewModel?
    {
        didSet{
            plBtn?.setTitle(baseData?.repostsCount, for: .normal)
            zfBtn?.setTitle(baseData?.commentsCount, for: .normal)
            zanBtn?.setTitle(baseData?.attitudescount, for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
        plBtn = self.createButton(title: "评论", imageName: "timeline_icon_comment")
        zfBtn = self.createButton(title: "转发", imageName: "timeline_icon_retweet")
        zanBtn = self.createButton(title: "赞", imageName: "timeline_icon_unlike")
        
        addSubview(plBtn!)
        addSubview(zfBtn!)
        addSubview(zanBtn!)
        
        zfBtn!.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(self)
            make.width.equalTo(plBtn!)
        }
        plBtn?.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self)
            make.left.equalTo(zfBtn!.snp.right)
            make.width.equalTo(zanBtn!)
        }
        zanBtn!.snp.makeConstraints { (make) in
            make.top.right.bottom.equalTo(self)
            make.left.equalTo(plBtn!.snp.right)
        }
    }
    
    
    
     func createButton(title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setBackgroundImage(UIImage(named: "timeline_card_bottom_background"), for: .normal)
        return button
    }

}
