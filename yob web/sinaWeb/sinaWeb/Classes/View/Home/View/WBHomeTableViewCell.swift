//
//  WBHomeTableViewCell.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/18.
//  Copyright © 2017年 Macx. All rights reserved.
/*
 
 */

import UIKit
import SnapKit
class WBHomeTableViewCell: UITableViewCell {

    var callBack:((String)->())?
    //  Mark:  ---懒加载控件
    lazy var originalView:WBOriginaView = WBOriginaView()
    
    lazy var barTool:WBTabtoolButton = WBTabtoolButton()
    
    lazy var reweetStatus:WBZFwebView = WBZFwebView()
    
    var topConstraint:Constraint?
        
    var baseData: WBBaseDataViewModel?
    {
        didSet{
            
            //print(baseData?.homeData?.source)
            
            originalView.baseData = baseData
            
            barTool.baseData = baseData
            
            topConstraint?.deactivate()
            //判断是否有转发微博
            if baseData?.homeData?.retweeted_status != nil{
                reweetStatus.isHidden = false
                reweetStatus.baseData = baseData
                barTool.snp.makeConstraints({ (make) in
                    topConstraint = make.top.equalTo(reweetStatus.snp.bottom).constraint
                })
            }else{
                reweetStatus.isHidden = true
                barTool.snp.makeConstraints({ (make) in
                    topConstraint = make.top.equalTo(originalView.snp.bottom).constraint
                })
            }
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    func setupUI()
    {
        contentView.addSubview(originalView)
        contentView.addSubview(barTool)
        contentView.addSubview(reweetStatus)
        //原创微博
        originalView.snp.makeConstraints { (make) in
            make.left.top.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-10)
        }
        //转发微博
        reweetStatus.snp.makeConstraints { (make) in
            make.top.equalTo(originalView.snp.bottom)
            make.left.right.equalTo(originalView)
        }
        //工具条
        barTool.snp.makeConstraints { (make) in
            make.left.right.equalTo(originalView)
            make.height.equalTo(30)
            topConstraint = make.top.equalTo(reweetStatus.snp.bottom).constraint
            make.bottom.equalTo(contentView)
        }
        
        originalView.callBack = {[weak self] (text) in
            self?.callBack?(text)
        }
        
    }

}
