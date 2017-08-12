//
//  WBWelcomeViewController.swift
//  sinaWeb
//
//  Created by Macx on 2017/6/7.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

import SnapKit
import SDWebImage

class WBWelcomeViewController: UIViewController {

    var backGImageView:UIImageView = UIImageView(image: UIImage(named: "ad_background"))
    
    //头像
    var iconImageView:UIImageView = {
        let imgV = UIImageView()
        
        if let urlStr = WBUserAccountViewModel.sharedViewModel.userAccount?.avatar_large{
        
            imgV.sd_setImage(with: URL(string:urlStr), placeholderImage: UIImage(named:"avatar_default_big"))
//            imgV.setImageWith(URL(string:urlStr)!, placeholderImage: UIImage(named:"avatar_default_big"))
        }
        imgV.layer.cornerRadius = 50
        imgV.layer.masksToBounds = true
        return imgV
        
        
        
    }()
    
    //昵称
    var disLabel:UILabel = {
        let lab = UILabel()
        //print(WBUserAccountViewModel.sharedViewModel.userAccount?.name)
        if let name = WBUserAccountViewModel.sharedViewModel.userAccount?.name{
            lab.text = "欢迎回来,\(name)"
        }else{
            lab.text = "欢迎回来"
        }
        
        lab.font = UIFont.systemFont(ofSize: 15)
        lab.textAlignment = .center
        return lab
    }()
    
    override func loadView()
    {
        view = backGImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }

    override func viewDidAppear(_ animated: Bool) {
        springAnimation()
    }
    
    func setupUI()
    {
        view.addSubview(iconImageView)
        view.addSubview(disLabel)
        disLabel.alpha = 0
        
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(200)
            make.size.equalTo(CGSize(width: 100, height:100))
            make.centerX.equalTo(self.view)
        }
        disLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            
        }
    }
    
    func springAnimation()
    {
        iconImageView.snp.updateConstraints { (make) in
            make.top.equalTo(self.view).offset(100)
        }
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 0.5,initialSpringVelocity: 10, options: [], animations: {
            self.view.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1, animations: {
                self.disLabel.alpha = 1
            }, completion: { (_) in
                //切换到主页
//                    let winD = UIApplication.shared.keyWindow
//                    
//                    winD?.rootViewController = WBHomeTableViewController()
                    
                    NotificationCenter.default.post(name: NSNotification.Name("isGetAccess_tokenAndUserInfo"), object: nil)
                
            })
        }
        
    }



}
