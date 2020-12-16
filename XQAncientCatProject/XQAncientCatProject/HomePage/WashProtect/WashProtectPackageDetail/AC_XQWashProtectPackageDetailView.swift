//
//  AC_XQWashProtectPackageDetailView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/8/14.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQWashProtectPackageDetailView: UIView {
    
    let scrollView = UIScrollView()
    let imgView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.scrollView.addSubview(self.imgView)
        self.addSubview(self.scrollView)
        
        
        // 布局
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let v = UIView()
        self.scrollView.addSubview(v)
        v.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        self.imgView.snp.makeConstraints { (make) in
//            make.edges.equalToSuperview()
            make.left.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        // 设置属性
        self.imgView.contentMode = .scaleAspectFill
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
