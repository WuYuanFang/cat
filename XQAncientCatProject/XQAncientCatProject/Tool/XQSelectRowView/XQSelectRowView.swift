//
//  XQSelectRowView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/9.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit

class XQSelectRowView: UIView {
    
    let titleLab = UILabel()
    
    let leftBtn = QMUIButton()
    let rightBtn = QMUIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLab)
        self.addSubview(self.leftBtn)
        self.addSubview(self.rightBtn)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
        }
        
        self.rightBtn.snp.makeConstraints { (make) in
            make.right.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        self.leftBtn.snp.makeConstraints { (make) in
            make.right.equalTo(self.rightBtn.snp.left).offset(-12)
            make.centerY.equalToSuperview()
            make.height.equalTo(self.rightBtn)
        }
        
        
        
        // 设置属性
        self.titleLab.font = UIFont.systemFont(ofSize: 15)
        
        self.rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.rightBtn.imagePosition = .right
        self.rightBtn.imageView?.contentMode = .scaleAspectFit
        self.rightBtn.spacingBetweenImageAndTitle = 8
        
        self.leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.leftBtn.imagePosition = .right
        self.leftBtn.imageView?.contentMode = .scaleAspectFit
        self.leftBtn.spacingBetweenImageAndTitle = 8
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

