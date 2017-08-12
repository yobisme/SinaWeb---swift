//
//  WBComposeView.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/21.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import pop
import YYModel
class WBComposeView: UIView {

    var target:UIViewController?
    
    lazy var composeList:[WBComposeListModel] = [WBComposeListModel]()
    
    fileprivate lazy var bgImageView: UIImageView = {
        //  图片模糊化处理
        let image = self.draw().applyLightEffect()
        let imageView = UIImageView(image: image)
        return imageView
    }()
    
    
    var composeBtnArray = [WBComposeButton]()
    
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
        loadPlistData()
        
        addSubview(bgImageView)
        self.backgroundColor = UIColor.blue

        //循环创建6个button
        
        //宽 高
        let width:CGFloat = 80
        let height:CGFloat = 110
        //间隔
        let margin = (UIScreen.main.bounds.size.width - 3 * width) / 4
        
        for i in 0..<6
        {
            let model = composeList[i]
            //行索引
            let rowIndex = i / 3
            //列索引
            let columnIndex = i % 3
            
            let x = (CGFloat(columnIndex) + 1) * margin + width * CGFloat(columnIndex)
            let y = (margin + height) * CGFloat(rowIndex)
            
            let composeBtn = WBComposeButton(frame: CGRect(x: x, y: y + UIScreen.main.bounds.size.height, width: width, height: height))
            
            composeBtn.setImage(UIImage(named:model.icon!), for: .normal)
            
            composeBtn.setTitle(model.title!, for: .normal)
            
            composeBtn.setTitleColor(UIColor.orange, for: .normal)
            
            composeBtnArray.append(composeBtn)
            
            composeBtn.tag = i
            
            composeBtn.addTarget(self, action: #selector(clickComposeBtn(btn:)), for: .touchUpInside)
            
            addSubview(composeBtn)
        }
    }
    
    //加载plist文件
    fileprivate func loadPlistData()
    {
        let path = Bundle.main.path(forResource: "composeBtn.plist", ofType: nil)!
        
        let array = NSArray(contentsOfFile: path)!
        
        composeList = NSArray.yy_modelArray(with: WBComposeListModel.self, json: array) as! [WBComposeListModel]
        
        
    }
    
    
    //点击按钮
    func clickComposeBtn(btn:WBComposeButton)
    {
        UIView.animate(withDuration: 0.3, animations: { 
            
            for comBtn in self.composeBtnArray
            {
                comBtn.alpha = 0.1
                //当前按钮
                if comBtn == btn
                {
                    comBtn.transform = CGAffineTransform(scaleX: 2, y: 2)
                    
                }else
                {
                //其他按钮
                    comBtn.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                }
            }
            
        }) { (_) in
            
            for comBtn in self.composeBtnArray
            {
                UIView.animate(withDuration: 0.3, animations: { 
                    
                    comBtn.transform = CGAffineTransform.identity
                    
                    comBtn.alpha = 1
                }) { (_) in
                    
                    let model = self.composeList[btn.tag]
                    
                    let classV = NSClassFromString(model.className!) as! UIViewController.Type
                    
                    let vc = classV.init()
                    
                    let nav = WBNavViewController(rootViewController: vc)
                    
                    self.target?.present(nav, animated: true, completion:
                    {
                        self.removeFromSuperview()
                    })
                 
                }
            }
        }
        
    }
    
    func draw()->(UIImage)
    {
        
        let winD = UIApplication.shared.keyWindow
        //开启上下文
        UIGraphicsBeginImageContext((winD?.bounds.size)!)
        
        winD?.drawHierarchy(in: (winD?.bounds)!, afterScreenUpdates: false)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        //关闭上下文
        UIGraphicsEndImageContext()
        
        return image!
        
        //image?.draw(in: (self.target?.view.bounds)!)
        
        
        
    }
    
    //弹簧动画
    func startPopAnimation(isAppear:Bool)
    {
        
        var offset:CGFloat = -350
        if isAppear == false
        {
            composeBtnArray = composeBtnArray.reversed()
            offset = 350
        }
        
        for (i,btn) in composeBtnArray.enumerated()
        {
            let popAnimation = POPSpringAnimation(propertyNamed: kPOPViewCenter)
            popAnimation?.toValue = CGPoint(x: btn.center.x, y: btn.center.y + offset)
            popAnimation?.springBounciness = 10
            popAnimation?.springSpeed = 10
            popAnimation?.beginTime = CACurrentMediaTime() + Double(i) * 0.1
            btn.pop_add(popAnimation, forKey: nil)
            
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        startPopAnimation(isAppear: false)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            
            self.removeFromSuperview()
        }
        
    }
    
    func show(target:UIViewController)
    {
        self.target = target
        
        //self.target?.view.addSubview(draw())
        
        self.frame = CGRect(origin: CGPoint.zero, size: target.view.bounds.size)

        startPopAnimation(isAppear: true)
    }

}
