//
//  AC_XQLevelPrivilegeView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQLevelPrivilegeView: UIView {
    
    let headerView = AC_XQLevelPrivilegeViewHeaderView()
    
    let levelView = AC_XQLevelPrivilegeViewLevelView()
    
    let webView = XQAutoHeightWebView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.headerView)
//        self.addSubview(self.levelView)
        self.addSubview(self.webView)
        
        // 布局
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(230)
        }
        
//        self.levelView.snp.makeConstraints { (make) in
//            make.bottom.left.right.equalToSuperview()
//            make.top.equalTo(self.headerView.snp.bottom)
//        }
        
        self.webView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(self.headerView.snp.bottom)
        }
        
        // 设置属性
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

