//
//  WBClickHighlightedTextViewController.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/29.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBClickHighlightedTextViewController: UIViewController {

    lazy var webView:UIWebView = UIWebView()
    
    override func loadView() {
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    var urlStr:String?{
        didSet{
            if let strUrl = urlStr{
                
                let req = URLRequest(url: URL(string:strUrl)!)
                
                webView.loadRequest(req)
            }
        }
        
    }
 

}
