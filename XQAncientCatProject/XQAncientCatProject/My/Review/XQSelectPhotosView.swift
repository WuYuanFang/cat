//
//  XQSelectPhotosView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

protocol XQSelectPhotosViewDelegate: NSObjectProtocol {
    
    /// 要选择图片
    func selectPhotosView(addImage selectPhotosView: XQSelectPhotosView)
    
    /// 点击了某个图片
    func selectPhotosView(_ selectPhotosView: XQSelectPhotosView, selectImg image: UIImage)
    
    /// 点击删除某个图片
    func selectPhotosView(_ selectPhotosView: XQSelectPhotosView, delete index: Int, image: UIImage)
}

class XQSelectPhotosView: UIView {
    
    weak var delegate: XQSelectPhotosViewDelegate?
    
    /// 选中的图片
    private var imgViewArr = [XQSelectPhotosViewImgView]()
    
    /// 当前选中的图片
    var imgArr = [UIImage]()
    
    /// 视图大小
    /// 中间两个间隔
//    private var imgSize: CGFloat = (SM_Screen_Width - 12 * 2)/3;
    
    /// 最大图片数量
    var maxCount = 3
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imgView1 = XQSelectPhotosViewImgView()
        let imgView2 = XQSelectPhotosViewImgView()
        let imgView3 = XQSelectPhotosViewImgView()
        self.imgViewArr.append(contentsOf: [
            imgView1, imgView2, imgView3
        ])
        self.xq_addSubviews(imgView1, imgView2, imgView3)
        
        // 布局
        
        let arr = NSArray.init(array: self.imgViewArr)
        arr.mas_distributeViews(along: .horizontal, withFixedSpacing: 12, leadSpacing: 0, tailSpacing: 0)
        arr.mas_makeConstraints { (make) in
            make?.height.equalTo()(self.imgViewArr[0].mas_width)
            make?.top.bottom()?.equalTo()(self)
        }
        
        // 设置属性
        
        self.xq_layoutImgView()
//        imgView.image = UIImage.init(named: "review_upImage")
        
        
        for (_, item) in self.imgViewArr.enumerated() {
            weak var weakSelf = self
            weak var weakItem = item
            
            // 点击删除
            item.deleteBtn.xq_addEvent(.touchUpInside) { (sender) in
                if let sItem = weakItem, let cIndex = weakSelf?.imgViewArr.firstIndex(of: sItem) {
                    weakSelf?.tagDelete(cIndex)
                }
            }
            
            // 点击图片
            item.imgView.isUserInteractionEnabled = true
            item.imgView.xq_addTap { (gesture) in
                
                if let sSelf = weakSelf, let sItem = weakItem {
                    if sItem.imgView.image?.isEqual(UIImage.init(named: "review_upImage")) ?? false {
                        sSelf.delegate?.selectPhotosView(addImage: sSelf)
                    }else {
                        if let img = sItem.imgView.image {
                            sSelf.delegate?.selectPhotosView(sSelf, selectImg: img)
                        }
                    }
                }
            }
            
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func tagDelete(_ delIndex: Int) {
        
        let img = self.imgArr.remove(at: delIndex)
        self.xq_layoutImgView()
        self.delegate?.selectPhotosView(self, delete: delIndex, image: img)
    }
    
    func addImage(_ img: UIImage) {
        self.addImages([img])
    }
    
    func addImages(_ imgs: [UIImage]) {
        
        if self.imgArr.count + imgs.count > self.maxCount {
            return
        }
        
        if self.imgArr.count >= self.maxCount {
            // 最大了
            return
        }
        
        self.imgArr.append(contentsOf: imgs)
        self.xq_layoutImgView()
    }
    
    private func xq_layoutImgView() {
        
        for item in self.imgViewArr {
            item.deleteBtn.isHidden = true
            item.imgView.image = nil
        }
        
        for (index, item) in self.imgArr.enumerated() {
            let imgView = self.imgViewArr[index]
            imgView.imgView.image = item
            imgView.deleteBtn.isHidden = false
        }
        
        if self.imgArr.count != self.maxCount {
            self.imgViewArr[self.imgArr.count].imgView.image = UIImage.init(named: "review_upImage")
            self.imgViewArr[self.imgArr.count].deleteBtn.isHidden = true
        }
    }
    
}

class XQSelectPhotosViewImgView: UIView {
    
    let deleteBtn = UIButton()
    let imgView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(imgView, deleteBtn)
        
        // 布局
        
        self.deleteBtn.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 20, height: 20))
        }
        
        self.imgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.deleteBtn.snp.centerY)
            make.right.equalTo(self.deleteBtn.snp.centerX)
            make.left.bottom.equalToSuperview()
            make.height.equalTo(self.imgView.snp.width)
        }
        
        // 设置属性
        
        self.deleteBtn.setBackgroundImage(UIImage.init(named: "review_delete"), for: .normal)
        
        self.imgView.layer.masksToBounds = true
        self.imgView.layer.cornerRadius = 4
        self.imgView.contentMode = .scaleAspectFill
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

