//
//  WBImageCollectionView.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/23.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import SVProgressHUD
class WBImageCollectionView: UICollectionView {

    var callBack:(()->())?
    
    var imagesArray:[UIImage] = [UIImage]()
    
    let flowLayout = UICollectionViewFlowLayout()
    
    let margin:CGFloat = 5
    
    let itemW = (UIScreen.main.bounds.size.width - 30) / 3
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout)
    {
        super.init(frame: frame, collectionViewLayout: flowLayout)
        
        flowLayout.itemSize = CGSize(width: itemW, height: itemW)
        
        flowLayout.minimumLineSpacing = margin
        
        flowLayout.minimumInteritemSpacing = margin
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI()
    {
        //backgroundColor = UIColor.lightGray
        
        dataSource = self
        delegate = self
        
        self.isHidden = true
        
        register(WBImageCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }

    
    func addImage(image:UIImage)
    {
        
        if imagesArray.count == 9
        {
            return
        }
        
        imagesArray.append(image)
        
        self.isHidden = imagesArray.count == 0
        
        reloadData()
    }
    
    
}

extension WBImageCollectionView:UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if imagesArray.count == 0 || imagesArray.count == 9
        {
            return imagesArray.count
        }
        
        return imagesArray.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! WBImageCollectionViewCell
        
        if indexPath.item == imagesArray.count
        {//显示加号
            cell.image = nil
        }else{
            cell.image = imagesArray[indexPath.item]
        }
        
        cell.deleteBtnCallBack = {[weak self] (currentCell)->() in

                let index = self?.indexPath(for: currentCell)
                
                self?.imagesArray.remove(at: index!.item)
            
                self?.isHidden = self?.imagesArray.count == 0
           
                self?.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == imagesArray.count
        {
            callBack?()
        }
    }
    
 
}



class WBImageCollectionViewCell: UICollectionViewCell
{
    var imageView:UIImageView = UIImageView()
    
    var deleteBtnCallBack:((WBImageCollectionViewCell)->())?
    
    lazy var deleteBtn:UIButton = {
        
        let btn = UIButton()
        
        btn.setImage(UIImage(named: "compose_photo_close"), for: .normal)
        
        btn.addTarget(self, action: #selector(clickDeleteBtn), for: .touchUpInside)
        
        return btn
    }()
  
    var image:UIImage?
    {
        didSet{
            
            if image == nil {
                
                imageView.image = UIImage(named: "compose_pic_add")
                
                deleteBtn.isHidden = true
                
            }else
            {
                imageView.image = image
                
                deleteBtn.isHidden = false
                
                //deleteBtn.setImage(UIImage(named: "compose_photo_close"), for: .normal)
    
            }
        }
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
       contentView.addSubview(imageView)
        contentView.addSubview(deleteBtn)
        
        imageView.snp.makeConstraints({ (make) in
            make.edges.equalTo(contentView)
        })
        deleteBtn.snp.makeConstraints { (make) in
            make.top.equalTo(imageView)
            make.right.equalTo(imageView)
        }
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //点击删除按钮
       func clickDeleteBtn(){
        
        deleteBtnCallBack?(self)

    }
}
