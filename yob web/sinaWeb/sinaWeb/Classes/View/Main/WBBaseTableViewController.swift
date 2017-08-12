//
//  WBBaseTableViewController.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/15.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBBaseTableViewController: UITableViewController {

    var isLogin: Bool = WBUserAccountViewModel.sharedViewModel.isLogin
    
    var vistorV: WBVistorView? = WBVistorView()
    
    override func loadView() {
        if isLogin {
            super.loadView()
        }else
        {
            view = vistorV 
            vistorV?.registerCallBack = {
                let loginVC = WBLoginViewController()
                let navVC = WBNavViewController(rootViewController: loginVC)
                self.present(navVC, animated: true, completion: nil)
            }
            
            vistorV?.loginCallBack = {
                let loginVC = WBLoginViewController()
                let navVC = WBNavViewController(rootViewController: loginVC)
                self.present(navVC, animated: true, completion: nil)
            }
            
            navigationItem.leftBarButtonItem = UIBarButtonItem.init(target: self, title: "注册", action: #selector(register))
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(target: self, title: "登录", action: #selector(login))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func register()
    {
        let loginVC = WBLoginViewController()
        let navVC = WBNavViewController(rootViewController: loginVC)
        self.present(navVC, animated: true, completion: nil)
    }
    
    func login()
    {
        let loginVC = WBLoginViewController()
        let navVC = WBNavViewController(rootViewController: loginVC)
        self.present(navVC, animated: true, completion: nil)
    }
}
