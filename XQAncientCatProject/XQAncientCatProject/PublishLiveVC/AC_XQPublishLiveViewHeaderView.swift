//
//  AC_XQPublishLiveViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit
import UITextField_Navigation

class AC_XQPublishLiveViewHeaderView: UIView {
    
    let titleLab = UILabel()
    let titleTF = QMUITextField()
    let desTV = QMUITextView()
    let desBackView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab, self.titleTF, self.desBackView, self.desTV)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(16)
        }
        
        self.titleTF.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.left.equalTo(self.titleLab.snp.right).offset(12)
        }
        
        self.desTV.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.desBackView).offset(12)
            make.right.bottom.equalTo(self.desBackView).offset(-12)
        }
        
        self.desBackView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(16)
            make.left.equalTo(self.titleLab)
            make.right.equalTo(-16)
            make.height.equalTo(120)
            make.bottom.equalToSuperview()
        }
        
        
        // 设置属性
        
        
        self.titleLab.text = "标题"
        
        self.titleTF.placeholder = "请输入标题"
        self.titleTF.font = UIFont.systemFont(ofSize: 15)
        
        self.desTV.font = UIFont.systemFont(ofSize: 15)
        self.desTV.placeholder = "请输入宠物简介"
        self.desTV.placeholderColor = UIColor.init(hex: "#999999")
        self.desTV.maximumTextLength = 100
        self.desTV.backgroundColor = UIColor.clear
        
        self.desBackView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.desBackView.layer.cornerRadius = 4
        
        
        self.titleTF.nextNavigationField = self.desTV
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}





