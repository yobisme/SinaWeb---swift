//
//  WBMineTableViewController.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/14.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBMineTableViewController: WBBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if isLogin
        {
            navigationItem.rightBarButtonItem = UIBarButtonItem.init(target: self, title: "push", action: #selector(loginText))
            
        }else{
            vistorV?.setImg(imageName: "visitordiscover_image_profile", title: "这个是我的界面,帅不?这个是我的界面,帅不?", isHomeVC: false)
        }

        
    }

    func loginText()
    {
        let textVC = WBTextViewController()
        
        navigationController?.pushViewController(textVC, animated: true)
    }
}
