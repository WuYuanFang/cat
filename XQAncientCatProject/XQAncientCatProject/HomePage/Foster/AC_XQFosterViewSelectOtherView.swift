//
//  AC_XQFosterViewSelectOtherView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/1.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQFosterViewSelectOtherView: UIView {
    /// 第一个
    let fSwitchView = XQSwitchRowView()
    /// 第二个
    let sSwitchView = XQSwitchRowView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.fSwitchView, self.sSwitchView)
        
        // 布局
        self.fSwitchView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(10)
            make.right.equalTo(-10)
        }
        
        self.sSwitchView.snp.makeConstraints { (make) in
            make.top.equalTo(self.fSwitchView.snp.bottom).offset(10)
            make.left.right.equalTo(self.fSwitchView)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        // 设置属性
        
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.layer.shadowOffset = CGSize.init(width: 8, height: 8)
        self.layer.shadowOpacity = 0.15
        self.layer.shadowColor = UIColor.black.cgColor
        
        self.fSwitchView.titleLab.font = UIFont.systemFont(ofSize: 13)
        self.sSwitchView.titleLab.font = UIFont.systemFont(ofSize: 13)
        
        self.fSwitchView.xq_switch.onTintColor = UIColor.ac_mainColor
        self.sSwitchView.xq_switch.onTintColor = UIColor.ac_mainColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
