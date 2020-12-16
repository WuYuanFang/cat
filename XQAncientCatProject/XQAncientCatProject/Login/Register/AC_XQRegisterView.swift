//
//  AC_XQRegisterView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/7.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool
import XQProjectTool_iPhoneUI

class AC_XQRegisterView: UIView {
    
    let headerView = AC_XQLoginViewHeaderView()
    
    let registerBtn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.headerView, self.registerBtn)
        
        // 布局
        self.headerView.snp.makeConstraints { (make) in
            make.height.equalToSuperview().multipliedBy(0.5)
            make.top.left.right.equalToSuperview()
        }
        
        self.registerBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom)
            make.size.equalTo(CGSize.init(width: 80, height: 80))
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        // 配置属性
        
        self.registerBtn.setBackgroundImage(UIImage.init(named: "loginBtn"), for: .normal)
        self.headerView.registerMode()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

