//
//  AC_XQWashProtectViewTakeView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/1.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 接送服务
class AC_XQWashProtectViewTakeView: AC_XQHomePageViewTableViewHeaderView {

    let xq_switch = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.xq_switch)
        
        // 布局
        self.xq_switch.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.left.equalTo(self.titleLab.snp.right).offset(12)
        }
        
        // 设置属性
        self.titleLab.text = "接送服务"
        self.subtitleLab.text = ""
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
