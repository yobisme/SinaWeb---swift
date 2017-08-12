//
//  WBMesseageTableViewController.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/14.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBMesseageTableViewController: WBBaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

      
        if !isLogin {
            vistorV?.setImg(imageName: "visitordiscover_image_message", title: "呵呵,消息呢,没有发现啊, 亲们给点力行不行", isHomeVC: false)
        }
    }
    
   

}
