//
//  WBPicView.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/20.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import SnapKit
import SDWebImage
//间隔
let Margin:CGFloat = 5
//每个的size
var SizeW:CGFloat = (UIScreen.main.bounds.size.width - 2 * Margin - 16) / 3

class WBPicView: UICollectionView
{
    var picUrls:[WBPicModel]?
    {
        didSet{
            
            guard let picUrls  = picUrls else {
                return
            }
            
            setSize(count: picUrls.count)
            
            reloadData()
            
        }
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout)
    {
        let flowLayout = UICollectionViewFlowLayout()

        flowLayout.itemSize = CGSize(width: SizeW, height: SizeW)
        
        flowLayout.minimumLineSpacing = Margin
        
        flowLayout.minimumInteritemSpacing = Margin
        
        super.init(frame: frame, collectionViewLayout: flowLayout)

        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupUI(){
        
        self.dataSource = self
        
        self.register(WBPicsViewCell.self, forCellWithReuseIdentifier: "cell")
        
    }
    
    
    
    // 计算行数列数和大小
    func setSize(count:Int)
    {
        
        //如果是单张图片
        
        if count == 1 {
            
            let imageUrl = picUrls!.first!.thumbnail_pic!
         
            if let localImage = SDWebImageManager.shared().imageCache?.imageFromDiskCache(forKey: imageUrl) {
       
                var imageSize = localImage.size
            
                if imageSize.width < 100 {
                    
                    let currentWidth: CGFloat = 100
                 
                    var currentheight = currentWidth / imageSize.width * imageSize.height
                   
                    if currentheight > 200 {
                        
                        currentheight = 200
                    }
                    //  计算好的大小
                    imageSize = CGSize(width: currentWidth, height: currentheight)
                }

                //  找到单张图片
                self.snp.updateConstraints({ (make) in
                    
                    make.size.equalTo(imageSize).priority(.high)
                })
                
                // 修改配图item的大小
                let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
                flowLayout.itemSize = imageSize
                
                return
            }
    
        }
        
        var columns = 0
        
        var rows = 0
       
        if count == 4 {
            
            columns = 2
            
            rows = 2
            
            setItemSize(columns: columns, rows: rows, sizeW: 130)
           
        }else if count == 2{
            
            columns = 2
            rows = 1
            setItemSize(columns: columns, rows: rows, sizeW: 150)
            
        }else{
            
            columns = count > 3 ? 3 : count
            //  行数计算
            rows = (count - 1) / 3 + 1
   
            setItemSize(columns: columns, rows: rows, sizeW: SizeW)
       }
    }
    
    
    func setItemSize(columns:Int,rows:Int,sizeW:CGFloat)
    {
        //  计算配图宽度
        let pictureVWidth = CGFloat(columns) * sizeW + CGFloat(columns - 1) * Margin
        //  计算配图高度
        let pictureVHeight =  CGFloat(rows) * sizeW + CGFloat(rows - 1) * Margin
        
        //  当前配图大小
        let pictureVSize = CGSize(width: pictureVWidth, height: pictureVHeight)
        
        self.snp.updateConstraints { (make) in
            
            make.size.equalTo(pictureVSize).priority(.high)
        }
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        flowLayout.itemSize = CGSize(width: sizeW, height: sizeW)
    }
    
}




//数据源方法
extension WBPicView:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picUrls?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WBPicsViewCell
        
        cell.picUrl = picUrls?[indexPath.row]
        
        return cell
    }
}
