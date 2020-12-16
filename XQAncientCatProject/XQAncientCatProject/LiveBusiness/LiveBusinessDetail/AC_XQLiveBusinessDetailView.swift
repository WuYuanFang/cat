//
//  AC_XQLiveBusinessDetailView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQProjectTool_iPhoneUI

class AC_XQLiveBusinessDetailView: UIView {
    
    let scrollView = UIScrollView()
    let payView = AC_XQLiveBusinessDetailViewPayView()
    
    let headerView = AC_XQLiveBusinessDetailViewHeaderView()
    let detailView = AC_XQLiveBusinessDetailViewDetailView()
    let showView = AC_XQLiveBusinessDetailViewShowView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.scrollView, self.payView)
        self.scrollView.xq_addSubviews(self.headerView, self.detailView, self.showView)
        
        // 布局
        self.scrollView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(self.payView.snp.top)
        }
        
        self.payView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
        
        let v = UIView()
        self.scrollView.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.left.right.top.equalToSuperview()
        }
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalTo(self.scrollView.snp.top).offset(-XQIOSDevice.getStatusHeight())
            make.left.right.equalToSuperview()
        }
        
        self.detailView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        self.showView.snp.makeConstraints { (make) in
            make.top.equalTo(self.detailView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-12)
        }
        
        // 设置属性
        
//        self.scrollView.backgroundColor = UIColor.red
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
