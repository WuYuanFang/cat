//
//  AC_XQShadowCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQShadowCell: UITableViewCell {

    private let xq_shadowContentView = UIView()
    
    let xq_contentView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(self.xq_shadowContentView)
        self.contentView.addSubview(self.xq_contentView)
        
        // 布局
        self.xq_normalLayout()
        
        // 设置属性
        self.selectionStyle = .none
        
        
        
        
        self.xq_contentView.backgroundColor = UIColor.white
        self.xq_contentView.layer.cornerRadius = 15
        self.xq_contentView.layer.masksToBounds = true
        
//        self.xq_contentView.layer.cornerRadius = 10;
//        self.xq_contentView.layer.shadowOffset = CGSize.init(width: 7, height: 7)
//        self.xq_contentView.layer.shadowOpacity = 0.15
//        self.xq_contentView.layer.shadowColor = UIColor.black.cgColor
        
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
            make.top.equalTo(7)
            make.bottom.equalTo(-7)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
    }
    
}
