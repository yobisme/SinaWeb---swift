//
//  WBTabBarViewController.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/14.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import SVProgressHUD
class WBTabBarViewController: UITabBarController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        let WBTab = WBTabBar()
        
        self.setValue(WBTab, forKey: "tabBar")
        
        //只读属性,可以通过kvc赋值
        //self.tabBar = WBTabBar()
        
        
        //点击加号按钮执行的方法
        WBTab.callBack = {
            
            if !WBUserAccountViewModel.sharedViewModel.isLogin
            {
                SVProgressHUD.showInfo(withStatus: "<<<请先登录哟>>>")
                return
            }
            
            let composeView = WBComposeView()
            
            composeView.show(target: self)
            
            self.view.addSubview(composeView)
            
            
        }
        

        addChildViewController(childController: WBHomeTableViewController(), title: "首页", imageName: "tabbar_home")
        addChildViewController(childController: WBDiscoverTableViewController(), title: "发现", imageName: "tabbar_discover")
        addChildViewController(childController: WBMesseageTableViewController(), title: "消息", imageName: "tabbar_message_center")
        addChildViewController(childController: WBMineTableViewController(), title: "我的", imageName: "tabbar_profile")
        
        
    }

   
    
    
    func addChildViewController(childController: UIViewController,title:String,imageName:String)
    {
        childController.title = title
        
        childController.tabBarItem.image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
        
        childController.tabBarItem.selectedImage = UIImage(named: "\(imageName)_selected")?.withRenderingMode(.alwaysOriginal)
        
        
        childController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.orange], for: .selected)
        
        let navVC = WBNavViewController.init(rootViewController: childController)
        
        super.addChildViewController(navVC)
        
    }
}
