//
//  WBNavViewController.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/14.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBNavViewController: UINavigationController,UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.interactivePopGestureRecognizer?.delegate = self
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0
        {
            viewController.hidesBottomBarWhenPushed = true
            
            if viewControllers.count == 1 {
                
                let title = viewControllers.first?.title
                
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(target: self, title:title!, action: #selector(popBack),imageName:"navigationbar_back_withtext_highlighted")
            }else
            {
                viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.init(target: self, title:"返回", action: #selector(popBack),imageName:"navigationbar_back_withtext_highlighted")
            }
            
            viewController.title = "显示的是第\(viewControllers.count)个控制器"
        }
        
        super.pushViewController(viewController, animated: true)
    }
    
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if viewControllers.count == 1 {
            return false
        }
        return true
    }
    
    
    
    func popBack()
    {
        self.popViewController(animated: true)
    }
    
}
