//
//  WBPicsViewCell.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import SDWebImage
class WBPicsViewCell: UICollectionViewCell {
    
    
    var picUrl:WBPicModel?{
        didSet{
            imageV.sd_setImage(with: URL(string:(picUrl?.thumbnail_pic)!), placeholderImage: UIImage(named: "avatar_default_big"))
            
            if (picUrl?.thumbnail_pic?.hasSuffix(".gif")) == true {
                gifImageView.isHidden = false
            }else{
                gifImageView.isHidden = true
            }
        }
    }
    
    
    lazy var imageV:UIImageView = {
        
        let picImage = UIImageView(image: UIImage(named: "avatar_default_big"))
        
        picImage.contentMode = .scaleAspectFill
        
        picImage.clipsToBounds = true
        
        return picImage
    }()
    //gif图片
    lazy var gifImageView:UIImageView = {
        let gif = UIImageView(image: UIImage(named: "timeline_image_gif"))
        
        return gif
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
        contentView.addSubview(imageV)
        contentView.addSubview(gifImageView)
        
        imageV.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
        }
        gifImageView.snp.makeConstraints { (make) in
            make.right.bottom.equalTo(contentView)
        }
    }
}
