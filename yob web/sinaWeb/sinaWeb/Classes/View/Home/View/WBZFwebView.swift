//
//  WBZFwebView.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import SnapKit

//转发微博view
class WBZFwebView: UIView
{
    var BottomContraint: Constraint?
    
    lazy var retweetedLabel:UILabel = {
        
        let textLab = UILabel()
        textLab.text = "哈哈哈哈哈哈啊哈哈哈哈哈哈啊哈哈哈哈哈哈啊哈哈哈gjhgka供货商东方国际"
        textLab.font = UIFont.systemFont(ofSize: 14)
        textLab.numberOfLines = 0
        textLab.textColor = UIColor.lightGray
        
        
        return textLab
        
    }()
    
    var baseData:WBBaseDataViewModel?
    {
        didSet{
            
//            retweetedLabel.text = baseData?.retweetedStr
            
            retweetedLabel.attributedText = baseData?.reweetedViewText
            
            BottomContraint?.deactivate()
            
            if let picSurl = baseData?.homeData?.retweeted_status?.pic_urls,picSurl.count > 0{
                picsView.isHidden = false
                
                self.snp.makeConstraints({ (make) in
                    BottomContraint = make.bottom.equalTo(picsView.snp.bottom).offset(8).constraint

                })
                
                picsView.picUrls = picSurl
            }else
            {
                picsView.isHidden = true
                
                self.snp.makeConstraints({ (make) in
                    BottomContraint = make.bottom.equalTo(retweetedLabel.snp.bottom).offset(8).constraint
                    
                })
            }
        }
    }
    
    lazy var picsView:WBPicView =
    {
       let picsV = WBPicView()
       
        picsV.backgroundColor = self.backgroundColor
        
        return picsV
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
        addSubview(retweetedLabel)
        addSubview(picsView)
        
        retweetedLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self)
        }
        
        picsView.snp.makeConstraints({ (make) in
            make.left.equalTo(self)
            make.top.equalTo(retweetedLabel.snp.bottom).offset(10)
            make.size.equalTo(CGSize(width: 100, height: 100)).priority(.high)
            
            
        })
        
        self.snp.makeConstraints { (make) in
            BottomContraint = make.bottom.equalTo(picsView.snp.bottom).offset(8).constraint
        }
    }

}
