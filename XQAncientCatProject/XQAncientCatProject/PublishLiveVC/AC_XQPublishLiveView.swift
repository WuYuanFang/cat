//
//  AC_XQPublishLiveView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/28.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit


class AC_XQPublishLiveView: UIView {
    
    let scrollView = UIScrollView()
    
    let headerView = AC_XQPublishLiveViewHeaderView()
    let infoView = AC_XQPublishLiveViewInfoView()
    let photoView = AC_XQPublishLiveViewPhotoView()
    let bottomView = AC_XQPublishLiveViewBottomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.scrollView)
        self.scrollView.xq_addSubviews(self.headerView, self.infoView ,self.photoView, self.bottomView)
        
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
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
        
        self.infoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        self.photoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
        }
        
        self.bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self.bottomView.snp.bottom).offset(35)
            make.left.right.equalToSuperview()
        }
        
        // 设置属性
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
