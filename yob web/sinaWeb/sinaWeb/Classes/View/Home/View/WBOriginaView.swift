//
//  WBOriginaView.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/18.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
import YYText
//原创微博

let margin = 8
class WBOriginaView: UIView
{
      var BottomContraint: Constraint?
    
    var callBack:((String)->())?
    
    var baseData:WBBaseDataViewModel?
    {
        didSet{
            if let imageUrl = baseData?.homeData?.user?.profile_image_url
            {
                iconImgView.sd_setImage(with: URL(string:imageUrl), placeholderImage: UIImage(named: "avatar_default_big"))
            }
            if let imgStr = baseData?.verifiedImg{
                
                verified_typeImg.image = UIImage(named:imgStr)
            }
            mbrank.image = baseData?.mbrank
            
            screen_name.text = baseData?.homeData?.user?.screen_name
            
            
            contentLabel.attributedText = baseData?.originaViewText
            
            //contentLabel.text = baseData?.homeData?.text
            
            source.text = baseData?.souceText
            
            BottomContraint?.deactivate()

            if let picSurl = baseData?.homeData?.pic_urls,picSurl.count > 0{
                picsView.isHidden = false
                self.snp.makeConstraints({ (make) in
                    BottomContraint = make.bottom.equalTo(picsView.snp.bottom).offset(margin).constraint
                    
                })
                
                picsView.picUrls = picSurl
            }else
            {
                picsView.isHidden = true
                
                self.snp.makeConstraints({ (make) in
                    BottomContraint = make.bottom.equalTo(contentLabel.snp.bottom).offset(margin).constraint
                    
                })
            }
            
            //给时间赋值
            timeLabel.text = baseData?.creatAt
            
        }
        
    }
    
    //  Mark:   ---加载控件
    
    lazy var picsView:WBPicView =
    {
        let picsV = WBPicView()
        
        picsV.backgroundColor = self.backgroundColor
        
        return picsV
    }()
    
    
    //头像
    lazy var iconImgView:UIImageView =
    {
         let imgView = UIImageView(image: UIImage(named: "avatar_default_big"))
        
        return imgView
    }()
    //认证图片
    lazy var verified_typeImg:UIImageView =
        {
            let imgView = UIImageView(image: UIImage(named: "avatar_enterprise_vip"))
            
            return imgView
    }()
    //会员等级图片
    lazy var mbrank:UIImageView =
        {
            let imgView = UIImageView(image: UIImage(named: "common_icon_membership_level1"))
            
            return imgView
    }()
    //昵称
    lazy var screen_name:UILabel =
    {
          let lab = UILabel()
        lab.text = "haha"
        lab.font = UIFont.systemFont(ofSize: 14)
        return lab
    }()
    //时间
    lazy var timeLabel:YYLabel =
        {
            let lab = YYLabel()
            lab.text = "刚刚"
            lab.font = UIFont.systemFont(ofSize: 12)
            lab.textColor = UIColor.orange
            return lab
    }()
    //来源
    lazy var source:UILabel =
        {
            let lab = UILabel()
            lab.text = "新浪微博"
            lab.font = UIFont.systemFont(ofSize: 14)
            return lab
    }()
    //内容
    lazy var contentLabel:YYLabel =
        {
            let lab = YYLabel()
            //lab.text = "haha黄金时代继父回家过段时间合法根据韩国公司电话静安寺盛开的较好的 看时间安徽的"
            //lab.font = UIFont.systemFont(ofSize: 14)
            lab.numberOfLines = 0
            lab.textColor = UIColor.darkGray
            lab.preferredMaxLayoutWidth = UIScreen.main.bounds.size.width - 20
            return lab
    }()
    
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  
    
    func setupUI()
    {
        //backgroundColor = UIColor.darkGray
        addSubview(iconImgView)
        addSubview(verified_typeImg)
        addSubview(mbrank)
        addSubview(screen_name)
        addSubview(timeLabel)
        addSubview(source)
        addSubview(contentLabel)
        addSubview(picsView)
        
        iconImgView.snp.makeConstraints { (make) in
            make.left.top.equalTo(self).offset(margin)
            make.size.equalTo(CGSize(width: 35, height: 35))
        }
        verified_typeImg.snp.makeConstraints { (make) in
            make.centerX.equalTo(iconImgView.snp.right)
            make.centerY.equalTo(iconImgView.snp.bottom)
        }
        screen_name.snp.makeConstraints { (make) in
            make.top.equalTo(iconImgView)
            make.left.equalTo(iconImgView.snp.right).offset(margin)
        }
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(screen_name)
            make.bottom.equalTo(iconImgView)
        }
        mbrank.snp.makeConstraints { (make) in
            make.left.equalTo(screen_name.snp.right).offset(margin)
            make.top.equalTo(screen_name)
        }
        source.snp.makeConstraints { (make) in
            make.bottom.equalTo(timeLabel)
            make.left.equalTo(timeLabel.snp.right).offset(margin)
        }
        contentLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImgView)
            make.top.equalTo(iconImgView.snp.bottom).offset(margin)
            make.right.equalTo(self)
        }
        
        picsView.snp.makeConstraints { (make) in
            make.left.equalTo(self)
            make.top.equalTo(contentLabel.snp.bottom).offset(margin)
            
            make.size.equalTo(CGSize(width: 100, height: 100)).priority(.high)
        }

        self.snp.makeConstraints { (make) in
           BottomContraint = make.bottom.equalTo(picsView).offset(margin).constraint
        }
        
        
        contentLabel.highlightTapAction = { (containerView, attributedText, range, rect) in
            //  containerView: 点击的视图contentLabel
            //  attributedText: 点击视图的富文本
            //  range: 点击高亮富文本的范围
            //  rect: 点击高亮的区域
            //  获取高亮的富文本
            let subAttributedText = attributedText.attributedSubstring(from: range)
            //  获取对应高亮富文本的字符串
            let text = subAttributedText.string
            
            if text.hasPrefix("http://"){
            
                self.callBack?(text)
               
            }
            
            
            print(text)
        }

    }
    
    
}
