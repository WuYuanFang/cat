//
//  AC_XQShadowCollectionViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/16.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQShadowCollectionViewCell: UICollectionViewCell {
    
    private let xq_shadowContentView = UIView()
    
    let xq_contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        self.contentView.addSubview(self.xq_shadowContentView)
        self.contentView.addSubview(self.xq_contentView)
        
        // 布局
        self.xq_normalLayout()
        
        // 设置属性
        
        
        self.xq_contentView.backgroundColor = UIColor.white
        self.xq_contentView.layer.cornerRadius = 15
        self.xq_contentView.layer.masksToBounds = true
        
        self.xq_shadowContentView.backgroundColor = UIColor.white
        self.xq_shadowContentView.layer.cornerRadius = 15
        self.xq_shadowContentView.layer.shadowOffset = CGSize.init(width: 0, height: 0)
        self.xq_shadowContentView.layer.shadowOpacity = 0.15
        self.xq_shadowContentView.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func xq_normalLayout() {
        self.xq_shadowContentView.snp.remakeConstraints { (make) in
            make.top.left.equalTo(self.xq_contentView).offset(1)
            make.right.bottom.equalTo(self.xq_contentView).offset(-1)
        }
        
        self.xq_contentView.snp.remakeConstraints { (make) in
//            make.top.equalTo(7)
//            make.bottom.equalTo(-7)
//            make.left.equalTo(15)
//            make.right.equalTo(-15)
            
            make.edges.equalToSuperview()
        }
    }
    
}
