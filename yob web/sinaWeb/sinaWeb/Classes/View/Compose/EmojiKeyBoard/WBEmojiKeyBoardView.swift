//
//  WBEmojiKeyBoardView.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/24.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

//自定义的表情键盘

class WBEmojiKeyBoardView: UIView
{
    //toolbar
    lazy var emojiBtnStackView:WBKeyBoardStackview =
    {
        let emojiV = WBKeyBoardStackview()
        
        emojiV.axis = .horizontal
        
        emojiV.distribution = .fillEqually
        
        return emojiV
    }()
    //表情
    lazy var emojiKeyBoardView:WBEmojiKeyBoardCollectionView =
    {
        let KB = WBEmojiKeyBoardCollectionView(frame:CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: 216 - 35)))
        
        //KB.backgroundColor = UIColor.orange
        
        return KB
    }()
    
    // 分页指示器
    lazy var pageControl:UIPageControl = {
        let pageC = UIPageControl()
        pageC.hidesForSinglePage = true
        pageC.setValue(UIImage(named: "compose_keyboard_dot_selected"), forKey: "_currentPageImage")
        pageC.setValue(UIImage(named: "compose_keyboard_dot_normal"), forKey: "_pageImage")
        
        return pageC
    }()
    

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
    
        addSubview(emojiBtnStackView)
        addSubview(emojiKeyBoardView)
        addSubview(pageControl)
        
        pageControl.currentPage = 0
        pageControl.numberOfPages = 6
//        pageControl.currentPageIndicatorTintColor = UIColor.orange
//        pageControl.pageIndicatorTintColor = UIColor.white
        
        pageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(emojiKeyBoardView)
            make.bottom.equalTo(emojiKeyBoardView)
            make.height.equalTo(10)
            //make.width.equalTo(100)
        }
        

        emojiBtnStackView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(35)
        }
        emojiKeyBoardView.snp.makeConstraints { (make) in
            make.right.top.left.equalTo(self)
            make.bottom.equalTo(emojiBtnStackView.snp.top)
        }
        
        
        emojiBtnStackView.EmojiBtnCallBack = {[weak self] (type) in
            
            let section = type.rawValue
         
            self?.emojiKeyBoardView.scrollToItem(at:IndexPath(item: 0, section: section - 11), at: [], animated: false)
        }
        
        emojiKeyBoardView.indexPathCallBack = { (indexpath)->() in
            
            
            self.pageControl.currentPage = indexpath.item
            self.pageControl.numberOfPages = WBEmoticonsTool.sharedTool.allDataArray[indexpath.section].count
            

        }
    
    }

}
