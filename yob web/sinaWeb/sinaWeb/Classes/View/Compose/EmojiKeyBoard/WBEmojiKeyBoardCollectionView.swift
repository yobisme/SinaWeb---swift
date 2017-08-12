//
//  WBEmojiKeyBoardCollectionView.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/24.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit

class WBEmojiKeyBoardCollectionView: UICollectionView {
    
    
    var indexPathCallBack:((IndexPath)->())?
 
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout)
    {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        flowLayout.itemSize = bounds.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        bounces = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        setupUI()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
        backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
        
        dataSource = self
        
        delegate = self
        
        let indexpath = IndexPath(item: 0, section: 1)
        
        scrollToItem(at: indexpath, at: [], animated: false)
        
        register(WBEmojiKeyBoardCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
  
    }
}


// 数据源方法
extension WBEmojiKeyBoardCollectionView:UICollectionViewDataSource,UICollectionViewDelegate
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return WBEmoticonsTool.sharedTool.allDataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WBEmoticonsTool.sharedTool.allDataArray[section].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WBEmojiKeyBoardCollectionViewCell
        cell.emoticonArray = WBEmoticonsTool.sharedTool.allDataArray[indexPath.section][indexPath.item]
        
        return cell
    }
    
    
    // 手动滚动实现联动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let centerX = scrollView.contentOffset.x + bounds.size.width * 0.5
        
        let centerY = bounds.size.height * 0.5

        let indexpath =  indexPathForItem(at: CGPoint(x: centerX, y: centerY))!
        
        NotificationCenter.default.post(name: NSNotification.Name("sendSection"), object: indexpath)
        
        //NotificationCenter.default.post(name: "sendSection", object: indexpath)
        
        indexPathCallBack?(indexpath)
           }
    
}


// MARK   --自定义cell
class WBEmojiKeyBoardCollectionViewCell: UICollectionViewCell {
    
    lazy var buttonArray:[WBEmoticonButton] = [WBEmoticonButton]()
    
    lazy var deleteButton:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named:"compose_emotion_delete"), for: .normal)
        btn.setImage(UIImage(named:"compose_emotion_delete_highlighted"), for: .normal)
        return btn
    }()
    
    var emoticonArray:[WBEmoticonsModel]?{
    
        didSet{
            
            for but in buttonArray{
                but.isHidden = true
            }
            if let array = emoticonArray{
                
                
                for (i,model) in array.enumerated()
                {
                    let button = buttonArray[i]
                    
                    button.emoticon = model
                   
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")

    }
    
    func setupUI()
    {
        setChildBut()
       
       
        
    }
    
    func setChildBut()
    {
        let btnW = self.bounds.size.width / 7
        let btnH = self.bounds.size.height / 3
        
        for i in 0..<20{
            //行,列索引
            let rows = i / 7
            let columns = i % 7
            let button = WBEmoticonButton()
            //button.setTitle("\(i)", for: .normal)
            button.frame = CGRect(x: CGFloat(columns) * btnW, y: CGFloat(rows) * btnH, width: btnW, height: btnH)
            contentView.addSubview(button)
            buttonArray.append(button)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 33)
            button.addTarget(self, action: #selector(clickBtn(btn:)), for: .touchUpInside)
    
        }
         //删除按钮
        contentView.addSubview(deleteButton)
        deleteButton.frame = CGRect(x: contentView.bounds.size.width - btnW, y: contentView.bounds.size.height - btnH, width: btnW, height: btnH)
        deleteButton.addTarget(self, action: #selector(clickDeleteBtn), for: .touchUpInside)
    }
    
    func clickBtn(btn:WBEmoticonButton){
        NotificationCenter.default.post(name: NSNotification.Name("sendBtn"), object: btn)
    }
    
    func clickDeleteBtn(){
        NotificationCenter.default.post(name: NSNotification.Name("clickDeleteBtn"), object: nil)
    }
}


