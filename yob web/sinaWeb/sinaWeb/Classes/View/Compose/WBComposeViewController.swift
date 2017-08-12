//
//  WBComposeViewController.swift
//  sinaWeb
//
//  Created by Macx on 2017/3/23.
//  Copyright © 2017年 Macx. All rights reserved.
//

import UIKit
import SVProgressHUD

class WBComposeViewController: UIViewController {

    lazy var titleLabel:UILabel =
    {
        let label = UILabel()
        
        if let name = WBUserAccountViewModel.sharedViewModel.userAccount?.name{
            
            let contentText = "发微博\n\(name)"
            
            let att = NSMutableAttributedString(string: contentText)
            
            let range = (contentText as NSString).range(of: name)
            
            att.setAttributes([NSFontAttributeName:UIFont.systemFont(ofSize: 13),NSForegroundColorAttributeName:UIColor.orange], range: range)
             label.numberOfLines = 0
    
            label.attributedText = att
        }else
        {
            label.text = "发微博"
        }
        label.sizeToFit()
        
        label.textAlignment = .center
        
       
        
        return label
            
    }()
    
    // 发送按钮
    lazy var senButton:UIButton =
    {
        let button = UIButton()
        
        button.addTarget(self, action: #selector(sendMesseage), for: .touchUpInside)
        
        button.setBackgroundImage(UIImage(named: "common_button_orange"), for: .normal)
        button.setBackgroundImage(UIImage(named: "common_button_orange_highlighted"), for: .highlighted)
        button.setBackgroundImage(UIImage(named: "common_button_white_disable"), for: .disabled)
        
        button.setTitle("发送", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor.darkGray, for: .disabled)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.bounds.size = CGSize(width: 45, height: 35)

        
        return button
    }()
    // textView输入框
    lazy var textView:WBTextView =
    {
        let textV = WBTextView()
        //能够垂直方向拖动
        textV.alwaysBounceVertical = true
        
        textV.font = UIFont.systemFont(ofSize: 14)
        
        //滚动的时候退出键盘
        textV.keyboardDismissMode = .onDrag
        
        return textV
    }()
    //图片collectionView
    lazy var imageCollectionView:WBImageCollectionView = {
       
        let imageC = WBImageCollectionView()
        
        return imageC
        
    }()
    //工具条
    lazy var toolBarView:WBToolBarStackView =
    {
        let toolB = WBToolBarStackView()
        toolB.axis = .horizontal
        toolB.distribution = .fillEqually
        return toolB
    }()
    
    //表情键盘
    lazy var emojiKeyBoard:WBEmojiKeyBoardView =
    {
        let keyB = WBEmojiKeyBoardView()
        
        keyB.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: UIScreen.main.bounds.size.width, height: 216))
        
        return keyB
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
    }
    
    
    fileprivate func setupUI()
    {
        //view.backgroundColor = UIColor.orange
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(target: self, title: "取消", action: #selector(cancel), imageName: nil)
        
        navigationItem.titleView = titleLabel
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: senButton)
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        
        view.addSubview(textView)
        textView.addSubview(imageCollectionView)
        view.addSubview(toolBarView)
        
        imageCollectionView.backgroundColor = textView.backgroundColor
        
        clickToolBar()
        
        clickAddImage()
        
        textView.delegate = self
        
        textView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.bottom.equalTo(toolBarView.snp.top)
        }
        
        imageCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(textView).offset(100)
            make.width.equalTo(textView).offset(-20)
            make.centerX.equalTo(textView)
            make.height.equalTo(textView.snp.width).offset(-20)
        }
        toolBarView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalTo(view)
            make.height.equalTo(40)
        }
        
        
        //监听键盘的改变
        NotificationCenter.default.addObserver(self, selector: #selector(changeKeyBoardFrame(noti:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sendEmoji(not:)), name: NSNotification.Name("sendBtn"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(deleteEmoticon), name: NSNotification.Name("clickDeleteBtn"), object: nil)
    }
    
    func sendEmoji(not:Notification){
        let btn = not.object as! WBEmoticonButton
        
        let model = btn.emoticon
        
        textView.emoticon = model
        
       WBEmoticonsTool.sharedTool.saveEmoticonWith(emoticonModel: model!) {
        
            let indexpath = IndexPath(item: 0, section: 0)
        
            self.emojiKeyBoard.emojiKeyBoardView.reloadItems(at: [indexpath])
        }
     
    }
    
    func deleteEmoticon(){
        
        textView.deleteBackward()
    }

    

    func changeKeyBoardFrame(noti:NSNotification)
    {
        let frame = noti.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
        
        toolBarView.snp.updateConstraints { (make) in
            make.bottom.equalTo(view).offset(frame.origin.y - UIScreen.main.bounds.size.height)
        }
        
        UIView.animate(withDuration: 0.3) { 
            self.view.layoutIfNeeded()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    //取消按钮
    func cancel()
    {
        textView.resignFirstResponder()
        
        dismiss(animated: true, completion: nil)
    }
    
    //发送按钮
    func sendMesseage()
    {
        //let text = textView.text
        
        var text = ""
        
        let range = NSMakeRange(0, textView.attributedText.length)
        
        textView.attributedText.enumerateAttributes(in: range, options: []) { (info, range, _) in
    
            //print(info,NSStringFromRange(range))
            
            if let attachment:WBEmoticonAttachment = info["NSAttachment"] as? WBEmoticonAttachment{
                
                let chs = attachment.emoticonModel?.chs
                
                text += chs!
            }else
            {
                let otherWordStr = textView.attributedText.attributedSubstring(from: range)
                
                text += otherWordStr.string
            }
        }
   
        let token = WBUserAccountViewModel.sharedViewModel.userAccount?.access_token
        
        SVProgressHUD.show()
        
        if let image = imageCollectionView.imagesArray.first{
            WBNetworkTool.sharedTools.sendWebDataWithTextAndPic(access_token: token!, text: text, pic: image, callBack: { (response, error) in
                
                if error != nil
                {
                    print(error!)
                    
                    SVProgressHUD.showError(withStatus: "发送失败")
                    return
                }
                SVProgressHUD.showSuccess(withStatus: "发送成功")
                
                self.dismiss(animated: true, completion: nil)
            })
            
            return
        }

        WBNetworkTool.sharedTools.sendWebDataWithText(access_token: token!, text: text) { (response, error) in
    
            if error != nil
            {
                print(error!)
                
                SVProgressHUD.showError(withStatus: "发送失败")
                return
            }
            SVProgressHUD.showSuccess(withStatus: "发送成功")
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK   --点击加号图片
    func clickAddImage()
    {
        imageCollectionView.callBack = { [weak self] in
            self?.addImages()
        }
    }
    
    // MARK   --点击toolbar
    func clickToolBar()
    {
        toolBarView.callBack = {[unowned self] (type:ToolBarStackViewBtnType)->() in
            
            switch type {
            case .picture:
                print("1")
                self.addImages()
            case .mention:
                print("2")
            case .trend:
                print("3")
            case .emoticon:
                self.checkKeyBoard()
            case .add:
                print("5")
            }
        }
    }
    // MARK   --点击表情,切换表情键盘,切换按钮图片
    func checkKeyBoard()
    {
        let but =  toolBarView.viewWithTag(3) as! UIButton
        
        if textView.inputView == nil
        {
            textView.inputView = emojiKeyBoard
            but.setImage(UIImage(named:"compose_keyboardbutton_background_highlighted"), for: .highlighted)
            but.setImage(UIImage(named:"compose_keyboardbutton_background"), for: .normal)
            
        }else{
            
            textView.inputView = nil
            but.setImage(UIImage(named:"compose_emoticonbutton_background"), for: .normal)
            but.setImage(UIImage(named: "compose_emoticonbutton_background_highlighted"), for: .highlighted)
            
        }
        
        textView.becomeFirstResponder()
        
        textView.reloadInputViews()
    }
}



// 点击图片按钮,添加图片
extension WBComposeViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    func addImages(){
        
        let imagePickerC = UIImagePickerController()
        
        imagePickerC.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            imagePickerC.sourceType = .camera
            
        }else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            imagePickerC.sourceType = .photoLibrary
        }
        
        self.present(imagePickerC, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        let imageSize = CGSize(width: 150, height: image.size.height / image.size.width * 150)
        
        //   图片上下文
        UIGraphicsBeginImageContext(imageSize)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: imageSize))
        
        let currentImg = UIGraphicsGetImageFromCurrentImageContext()

        UIGraphicsEndImageContext()
        
        imageCollectionView.addImage(image: currentImg!)
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}


extension WBComposeViewController:UITextViewDelegate
{
    func textViewDidChange(_ textView: UITextView)
    {
        navigationItem.rightBarButtonItem?.isEnabled = textView.hasText
    }
}
