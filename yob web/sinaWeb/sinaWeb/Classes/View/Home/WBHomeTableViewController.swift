//
//  WBHomeTableViewController.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/24.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import YYModel

class WBHomeTableViewController: WBBaseTableViewController {

    var homeData:WBHomeDataViewModel? = WBHomeDataViewModel()
    
    var activityIndicator:UIActivityIndicatorView = {
        
        let acInd = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        acInd.color = UIColor.blue
        return acInd
    }()
    
    var downRefresh:WBRefreshControll = {
        
       let down = WBRefreshControll()
        
        down.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        return down
    }()
    //提示刷新了多少条数据
    lazy var tipLabel:UILabel = {
        let tip = UILabel()
        tip.backgroundColor = UIColor.orange
        tip.text = "没有加载出最新的微博数据.."
        tip.textAlignment = .center
        tip.font = UIFont.systemFont(ofSize: 14)
        
        tip.isHidden = true
        return tip
    }()
    
    //下拉刷新数据
     func refreshData()
    {
        loadData(isUp: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if !isLogin
        {
            vistorV?.setImg(imageName: nil, title: nil, isHomeVC: true)
        }else
        {
            loadData(isUp: true)
            
            tableView.register(WBHomeTableViewCell.self, forCellReuseIdentifier: "cell")
            //自动计算行高
            tableView.rowHeight = UITableViewAutomaticDimension
            
            tableView.estimatedRowHeight = 200
            //去掉分割线
            tableView.separatorStyle = .none
            
            tableView.tableFooterView = activityIndicator
            
            tableView.addSubview(downRefresh)
            
            self.navigationController?.view.insertSubview(tipLabel, belowSubview: (navigationController?.navigationBar)!)
            
            tipLabel.frame = CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY - 40, width: (self.navigationController?.navigationBar.bounds.size.width)!, height: 40)
            
            //self.refreshControl = downRefresh
        }
    }
    
    
    func loadData(isUp:Bool)
    {
        //print(WBUserAccountViewModel.sharedViewModel.userAccount?.name)
        
        homeData?.loadHomeData(isUp:isUp,callBack: { (isSuccess,message) in
            
            self.startTipAnimation(text: message)
            
            self.activityIndicator.stopAnimating()
            
            self.downRefresh.endRefreshing()
            
            if isSuccess
            {
                self.tableView.reloadData()
            }
            
        })
    }
    
    func startTipAnimation(text:String)
    {
        tipLabel.text = text
        tipLabel.isHidden = false
        
        UIView.animate(withDuration: 1, animations: { 
            
            self.tipLabel.transform = CGAffineTransform(translationX: 0, y: self.tipLabel.bounds.size.height)
            
        }) { (_) in
            
            UIView.animate(withDuration: 1, animations: { 
                self.tipLabel.transform = CGAffineTransform.identity
            }, completion: { (_) in
                self.tipLabel.isHidden = true
            })
            
        }
        
        
    }
    
}
//数据源方法
extension WBHomeTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeData!.baseDataListArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! WBHomeTableViewCell
        
        let viewModel =  homeData?.baseDataListArray[indexPath.row]
        
        cell.baseData = viewModel
        
        cell.selectionStyle = .none
        
        cell.callBack = { [weak self] (text) in
            let vc = WBClickHighlightedTextViewController()
            vc.urlStr = text
            //let nav = WBNavViewController(rootViewController: vc)
            self?.navigationController?.pushViewController(vc, animated: true)
           // self?.present(nav, animated: true, completion: nil)
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == (homeData?.baseDataListArray.count)! - 1 && !activityIndicator.isAnimating
        {
            activityIndicator.startAnimating()
            
            loadData(isUp: true)
        }
    }
}
