//
//  AC_XQVIPView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQVIPView: UIView {
    
    
    let scrollView = UIScrollView()
    let headerView = AC_XQVIPViewHeaderView()
    let privilegeView = AC_XQVIPViewPrivilegeView()
    let welfareView = AC_XQMoreView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.scrollView)
        self.scrollView.addSubview(self.headerView)
        self.scrollView.addSubview(self.privilegeView)
        self.scrollView.addSubview(self.welfareView)
        
        // 布局
        
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let v = UIView()
        self.scrollView.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
        }
        
        self.privilegeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
        }
        
        self.welfareView.snp.makeConstraints { (make) in
            make.top.equalTo(self.privilegeView.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-20)
        }
        
        // 设置属性
        
        self.scrollView.contentInsetAdjustmentBehavior = .never
        
        self.welfareView.titleLab.text = "专属福利"
        self.welfareView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
