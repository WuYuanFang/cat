//
//  XQJGGView.swift
//  XQShopMallProject
//
//  Created by WXQ on 2020/4/25.
//  Copyright © 2020 itchen.com. All rights reserved.
//

import UIKit

protocol XQJGGViewDelegate: NSObjectProtocol {
    
    func jggView(_ jggView: XQJGGView, didSelectRowAt index: Int)
    
}

/// 九宫格
class XQJGGView: UIView {
    
    weak var delegate: XQJGGViewDelegate?

    /// 0 ~ 2
    let imgContainerView0 = UIView()
    /// 3 ~ 5
    let imgContainerView1 = UIView()
    /// 6 ~ 8
    let imgContainerView2 = UIView()
    /// 粗暴点, 直接9个
    let imgViewArr = [
        UIImageView(),
        UIImageView(),
        UIImageView(),
        UIImageView(),
        UIImageView(),
        UIImageView(),
        UIImageView(),
        UIImageView(),
        UIImageView(),
    ]
    
    private var fixedSpacing: CGFloat = 0
    private var leadSpacing: CGFloat = 0
    private var tailSpacing: CGFloat = 0
    private var itemSize: CGFloat = 0
    
    init(frame: CGRect, itemSize: CGFloat, fixedSpacing: CGFloat, leadSpacing: CGFloat, tailSpacing: CGFloat) {
        super.init(frame: frame)
        
        self.itemSize = itemSize
        self.fixedSpacing = fixedSpacing
        self.leadSpacing = leadSpacing
        self.tailSpacing = leadSpacing
        
        weak var weakSelf = self
        self.xq_addSubviews(self.imgContainerView0, self.imgContainerView1, self.imgContainerView2)
        for (index, item) in self.imgViewArr.enumerated() {
            
            item.isUserInteractionEnabled = true
            item.tag = 1000 + index
            item.xq_addTap { (gesture) in
                if let tag = gesture?.view?.tag, let sSelf = weakSelf {
                    weakSelf?.delegate?.jggView(sSelf, didSelectRowAt: tag - 1000)
                }
            }
            
            if index < 3 {
                self.imgContainerView0.addSubview(item)
            }else if index < 6 {
                self.imgContainerView1.addSubview(item)
            }else {
                self.imgContainerView2.addSubview(item)
            }
            
            item.isHidden = true
            item.contentMode = .scaleAspectFill
            item.layer.cornerRadius = 4
            item.layer.masksToBounds = true
//            item.backgroundColor = UIColor.orange
        }
        
        
        
        // 布局
        
        let arr3 = NSArray.init(array: [self.imgContainerView0, self.imgContainerView1, self.imgContainerView2])
        arr3.mas_remakeConstraints { (make) in
            make?.left.right()?.equalTo()(self)
            make?.height.mas_equalTo()(self.itemSize)
        }
        arr3.mas_distributeViews(along: .vertical, withFixedSpacing: fixedSpacing, leadSpacing: leadSpacing, tailSpacing: leadSpacing)
        
        
        let arr0 = NSArray.init(array: [self.imgViewArr[0], self.imgViewArr[1], self.imgViewArr[2]])
        let arr1 = NSArray.init(array: [self.imgViewArr[3], self.imgViewArr[4], self.imgViewArr[5]])
        let arr2 = NSArray.init(array: [self.imgViewArr[6], self.imgViewArr[7], self.imgViewArr[8]])
        
        
        arr0.mas_makeConstraints { (make) in
            make?.width.mas_equalTo()(itemSize)
            make?.top.equalTo()(self.imgContainerView0)
            make?.bottom.equalTo()(self.imgContainerView0)
        }
        
        arr1.mas_makeConstraints { (make) in
            make?.width.mas_equalTo()(itemSize)
            make?.top.equalTo()(self.imgContainerView1)
            make?.bottom.equalTo()(self.imgContainerView1)
        }
        
        arr2.mas_makeConstraints { (make) in
            make?.width.mas_equalTo()(itemSize)
            make?.top.equalTo()(self.imgContainerView2)
            make?.bottom.equalTo()(self.imgContainerView2)
        }
        
        arr0.mas_distributeViews(along: .horizontal, withFixedSpacing: fixedSpacing, leadSpacing: leadSpacing, tailSpacing: leadSpacing)
        arr1.mas_distributeViews(along: .horizontal, withFixedSpacing: fixedSpacing, leadSpacing: leadSpacing, tailSpacing: leadSpacing)
        arr2.mas_distributeViews(along: .horizontal, withFixedSpacing: fixedSpacing, leadSpacing: leadSpacing, tailSpacing: leadSpacing)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImgUrlStr(_ urls: [String]) {
        var urlArr = [URL]()
        for item in urls {
            if let url = URL.init(string: item) {
                urlArr.append(url)
            }
        }
        self.setImgUrl(urlArr)
    }
    
    /// 设置图片, 没有, 就传 空数组
    func setImgUrl(_ urls: [URL]) {
        
        for item in self.imgViewArr {
            item.isHidden = true
        }
        
        for (index, item) in urls.enumerated() {
            
            if index == self.imgViewArr.count {
                break
            }
            
            let imgView = self.imgViewArr[index]
            imgView.isHidden = false
            
            imgView.sd_setImage(with: item, placeholderImage: UIImage.init(named: "xq_unknow"), completed: nil)
            
        }
        
        
        let arr3 = NSArray.init(array: [self.imgContainerView0, self.imgContainerView1, self.imgContainerView2])
        arr3.mas_remakeConstraints { (make) in
            
        }
        
        if urls.count == 0 {
            
            self.imgContainerView0.snp.remakeConstraints { (make) in
                make.top.left.bottom.right.equalToSuperview()
                make.height.equalTo(0)
            }
            
        }else if urls.count <= 3 {
            
            self.imgContainerView0.snp.remakeConstraints { (make) in
                make.top.left.bottom.right.equalToSuperview()
                make.height.equalTo(self.itemSize)
            }
            
        }else if urls.count <= 6 {
            
            let arr = NSArray.init(array: [self.imgContainerView0, self.imgContainerView1])
            arr.mas_remakeConstraints { (make) in
                make?.left.right()?.equalTo()(self)
                make?.height.mas_equalTo()(self.itemSize)
            }
            arr.mas_distributeViews(along: .vertical, withFixedSpacing: fixedSpacing, leadSpacing: leadSpacing, tailSpacing: leadSpacing)
            
        }else {
            
            arr3.mas_remakeConstraints { (make) in
                make?.left.right()?.equalTo()(self)
                make?.height.mas_equalTo()(self.itemSize)
            }
            arr3.mas_distributeViews(along: .vertical, withFixedSpacing: fixedSpacing, leadSpacing: leadSpacing, tailSpacing: leadSpacing)
            
            
        }
        
    }
    
}
