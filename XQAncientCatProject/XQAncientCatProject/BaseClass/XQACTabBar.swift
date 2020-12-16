//
//  XQACTabBar.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2019/12/25.
//  Copyright © 2019 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool
import XQProjectTool_iPhoneUI

class XQACTabBar: UITabBar {
    
    /// 自定义 tabbar 内容 view
    let contentView = XQACTabBarContentView()
    
    /// 阴影view
    private let contentBackView = UIView()

    /// 圆角
    private let xq_radius: CGFloat = 10
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        self.contentView.backgroundColor = UIColor.orange
        self.contentView.backgroundColor = UIColor.white
        self.contentView.layer.masksToBounds = false
        
        self.contentBackView.backgroundColor = UIColor.white
        self.contentBackView.layer.shadowColor = UIColor.black.cgColor
        self.contentBackView.layer.shadowOffset = CGSize.init(width: 0, height: -20)
        self.contentBackView.layer.shadowRadius = self.xq_radius
        self.contentBackView.layer.shadowOpacity = 0.08
        self.contentBackView.layer.masksToBounds = false
        
        
        
        self.tintColor = UIColor.black
        self.isTranslucent = false
        
        // 这个设置是头部横线去掉...但是设置了, 又看不到阴影了...卧槽
        // 只能去取具体里面的view去掉了
//        self.clipsToBounds = true
        self.layer.masksToBounds = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 去掉头部横线
        for item in self.subviews {
            let str = NSStringFromClass(item.classForCoder)
            if str == "_UIBarBackground" {
                item.clipsToBounds = true
            }
        }
        
        // 插入到最前面
        self.insertSubview(self.contentBackView, at: self.subviews.count)
        self.insertSubview(self.contentView, at: self.subviews.count)
        
        self.contentView.snp.remakeConstraints { (make) in
            make.top.equalTo(self)
            make.left.right.bottom.equalTo(self)
        }
        
        self.contentBackView.snp.remakeConstraints { (make) in
            make.top.equalTo(self).offset(self.xq_radius)
            make.left.right.bottom.equalTo(self)
        }
        
        // 头部圆角
        let rectCorner = UIRectCorner.topLeft.rawValue | UIRectCorner.topRight.rawValue
        self.contentView.xq_corners_addRoundedCorners(UIRectCorner(rawValue: rectCorner), withRadii: CGSize.init(width: self.xq_radius, height: self.xq_radius))
        
    }
    
    
    
}
