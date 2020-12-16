//
//  AC_XQPublishLiveViewInfoView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit



class AC_XQPublishLiveViewInfoView: AC_XQPublishLiveViewCommonView {
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 布局
        
        // 设置属性
        self.titleView.titleLab.text = "填写宠物信息"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class AC_XQPublishLiveViewCommonView: UIView {
    
    let titleView = AC_XQPublishLiveViewInfoViewTitleView()
    let contentView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleView, self.contentView)
        
        // 布局
        
        self.titleView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(16)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleView.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.bottom.equalToSuperview()
        }
        
        // 设置属性
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


class AC_XQPublishLiveViewInfoViewTitleView: UIView {
    
    let lineView = UIView()
    let titleLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.lineView, self.titleLab)
        
        // 布局
        self.lineView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(3)
            make.height.equalTo(self.titleLab)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineView.snp.right).offset(5)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        // 设置属性
        
        self.lineView.backgroundColor = UIColor.ac_mainColor
        
        self.titleLab.font = UIFont.systemFont(ofSize: 15)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


