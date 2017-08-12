//
//  WBDiscoverTableViewController.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/14.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBDiscoverTableViewController: WBBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if !isLogin {
            vistorV?.setImg(imageName: "visitordiscover_image_message", title: "有会发现的眼睛吗?没有的话,就去切点洋葱,刺激一下眼睛", isHomeVC: false)
        }
        
    }
    
   
}
