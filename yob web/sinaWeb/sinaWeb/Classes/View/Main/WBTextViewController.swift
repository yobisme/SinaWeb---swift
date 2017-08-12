//
//  WBTextViewController.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/14.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBTextViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(target: self, title: "push", action: #selector(push))

        
    }

    func push()
    {
        let textVC = WBTextViewController()
        
        navigationController?.pushViewController(textVC, animated: true)
    }

}
