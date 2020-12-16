//
//  AC_XQReviewView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import XQUITextField_Navigation

class AC_XQReviewView: UIView {

    let reviewLab = UILabel()
    let starView = XQStarView.init(frame: CGRect.zero, starCount: 5, starSelectIndex: 4)
    let lineView = UIView()
    
    let tv = UITextView()
    
    let upImgView = XQSelectPhotosView()
    
    let anonymousView = XQSwitchRowView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.reviewLab, self.starView, self.lineView, self.tv, self.upImgView, self.anonymousView)
        
        // 布局
        self.reviewLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.starView)
            make.left.equalTo(12)
        }
        
        self.starView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(self.reviewLab.snp.right).offset(12)
            make.height.equalTo(20)
        }
        
        self.lineView.snp.makeConstraints { (make) in
            make.top.equalTo(self.starView.snp.bottom).offset(12)
            make.height.equalTo(1)
            make.left.right.equalToSuperview()
        }
        
        self.tv.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView.snp.bottom)
            make.left.equalTo(self.reviewLab)
            make.right.equalTo(-12)
            make.height.equalTo(160)
        }
        
        self.upImgView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tv.snp.bottom).offset(12)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        self.anonymousView.snp.makeConstraints { (make) in
            make.top.equalTo(self.upImgView.snp.bottom).offset(20)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        // 设置属性
        
        self.reviewLab.text = "评分"
        self.reviewLab.font = UIFont.systemFont(ofSize: 15)
        
        self.lineView.backgroundColor = UIColor.init(hex: "#EEEEEE")
        
        self.tv.placeholder = "输入您的评价"
        self.tv.applyInputAccessoryView()
        self.tv.font = UIFont.systemFont(ofSize: 15)
        
        self.anonymousView.titleLab.text = "匿名评价"
        self.anonymousView.xq_switch.isOn = true
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

