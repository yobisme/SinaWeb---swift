//
//  WBVistorView.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/15.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import SnapKit
class WBVistorView: UIView {
    
    //注册闭包
    var registerCallBack:(()->())?
    //登录闭包
    var loginCallBack:(()->())?
    //转圈的图
    fileprivate lazy var cycleImgView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_smallicon"))
    //蒙板
    fileprivate lazy var mbImgView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_mask_smallicon"))
    //房子
    fileprivate lazy var houseImgView:UIImageView = UIImageView(image: UIImage(named: "visitordiscover_feed_image_house"))
    //label
    lazy var disLabel: UILabel = {
        let disL = UILabel()
        disL.text = "赶快注册吧赶快注册吧赶快注册吧赶快注册吧赶快注册吧赶快注册吧"
        disL.numberOfLines = 0
        disL.textAlignment = .center
        disL.font = UIFont.systemFont(ofSize: 14)
        disL.textColor = UIColor.darkGray
        return disL
    }()
    //注册
    lazy var registerButton:UIButton = {
       let but = UIButton()
        but.setTitle("注册", for: .normal)
        but.setTitleColor(UIColor.darkGray, for: .normal)
        but.setTitleColor(UIColor.orange, for: .highlighted)
        var img = UIImage(named: "common_button_white_disable")
        img = img?.stretchableImage(withLeftCapWidth: 5, topCapHeight: 5)
        but.setBackgroundImage(img, for: .normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        but.adjustsImageWhenDisabled = false
        but.addTarget(self, action: #selector(clickRegisterBtn), for: .touchUpInside)
        return but
    }()
     
    //登录
    lazy var loginButton:UIButton = {
        let but = UIButton()
        but.setTitle("登录", for: .normal)
        but.setTitleColor(UIColor.darkGray, for: .normal)
        but.setTitleColor(UIColor.orange, for: .highlighted)
        var img = UIImage(named: "common_button_white_disable")
        img = img?.stretchableImage(withLeftCapWidth: 5, topCapHeight: 5)
        but.setBackgroundImage(img, for: .normal)
        but.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        but.adjustsImageWhenDisabled = false
        but.addTarget(self, action: #selector(clickLoginBtn), for: .touchUpInside)
        return but
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setupUI()
    {
        backgroundColor = UIColor(white: 237/255.0, alpha: 1)
        
        cycleImgView.layer.cornerRadius = cycleImgView.bounds.size.width * 0.5
        cycleImgView.layer.masksToBounds = true
        
        addSubview(cycleImgView)
        addSubview(mbImgView)
        addSubview(houseImgView)
        addSubview(disLabel)
        addSubview(registerButton)
        addSubview(loginButton)
        
        cycleImgView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            
        }
        mbImgView.snp.makeConstraints { (make) in
            make.center.equalTo(cycleImgView)
        }
        houseImgView.snp.makeConstraints { (make) in
            make.center.equalTo(cycleImgView)
        }
        disLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cycleImgView.snp.bottom).offset(30)
            make.centerX.equalTo(cycleImgView)
            make.size.equalTo(CGSize.init(width: 220, height: 35))
        }
        registerButton.snp.makeConstraints { (make) in
            make.left.equalTo(disLabel)
            make.width.equalTo(60)
            make.top.equalTo(disLabel.snp.bottom).offset(10)
        }
        loginButton.snp.makeConstraints { (make) in
            make.right.equalTo(disLabel)
            make.width.equalTo(60)
            make.top.equalTo(disLabel.snp.bottom).offset(10)
        }
       
    }
    
    
    func startAnimation()
    {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = 2 * Double.pi
        
        animation.duration = 20
        
        animation.repeatCount = MAXFLOAT
        
        animation.isRemovedOnCompletion = false
        
        cycleImgView.layer.add(animation, forKey: nil)
    }
    
    func setImg(imageName:String?,title:String?,isHomeVC:Bool)
    {
        if isHomeVC {
             startAnimation()
        }else
        {
            cycleImgView.isHidden = true
            mbImgView.isHidden = true
            houseImgView.image = UIImage(named: imageName!)
            disLabel.text = title
            
        }
    }
    
    //点击按钮
    func clickRegisterBtn()
    {
        registerCallBack?()
    }
    
    func clickLoginBtn()
    {
        loginCallBack?()
    }
}
