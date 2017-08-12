//
//  WBLoginViewController.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/17.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
//document.getElementById('userId').value = '1250761855@qq.com';

//document.getElementById('passwd').value = 'wujian5636547270';

//code=8e329cc787324a1152e7ee2f22abe5e1
import SVProgressHUD

class WBLoginViewController: UIViewController {

    var wbView: UIWebView? = UIWebView()
    
    var client_id:String? = "1638251349"
    
    var redirect_uri:String? = "http://www.itcast.cn"
    
    override func loadView() {
        view = wbView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wbView?.delegate = self
        
        setupUI()
        
    }

    func setupUI() {
        
        let urlStr = "https://api.weibo.com/oauth2/authorize?client_id=\(client_id!)&redirect_uri=\(redirect_uri!)"
        
        print(urlStr)
        
        let urlReq = URLRequest(url: URL(string: urlStr)!)
        
        wbView?.loadRequest(urlReq)
        
        navigationItem.title = "微博登录"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(target: self, title: "取消", action: #selector(cancelAction))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(target: self, title: "自动填充", action: #selector(autoFillAction))
        
    }
    
    func cancelAction()
    {
        dismiss(animated: true, completion: nil)
    }
    //自动填充按钮
    func autoFillAction()
    {
        wbView?.stringByEvaluatingJavaScript(from: "document.getElementById('userId').value = '1250761855@qq.com';document.getElementById('passwd').value = 'wujian5636547270';")
    }

}

extension WBLoginViewController:UIWebViewDelegate
{
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        //拦截请求
        if (request.url?.absoluteString.hasPrefix(redirect_uri!))!
        {
            if let query = request.url?.query,query.hasPrefix("code=")
            {
                //print(query)
                let code = query.substring(from: ("code=").endIndex)
                
                print(code)
                
                let params = [
                    "client_id":client_id,
                    "client_secret":"1cfd3a41c0c43a271f52ccba66f4b2f1",
                    "grant_type":"authorization_code",
                    "code":code,
                    "redirect_uri":redirect_uri,
                    ]
                //获取令牌和用户信息
                WBUserAccountViewModel.sharedViewModel.getAccess_tokenAndUserInfo(params: params, callBack: { (isTrue) in
                    if isTrue{
                        
                        let isSucesses:String = "true"
                        
                        self.dismiss(animated: false, completion: {
                            NotificationCenter.default.post(name: NSNotification.Name("isGetAccess_tokenAndUserInfo"), object: isSucesses)
                            
                        })
                    }
                    
                })
                
                //切换到欢迎页面
                
            }else
            {
                self.dismiss(animated: true, completion: nil)
                
                //print(query!)
                
            }
            return false
        }
        
        return true
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        SVProgressHUD.show()
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        SVProgressHUD.dismiss()
    }
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        SVProgressHUD.dismiss()
    }
}
