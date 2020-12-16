//
//  AC_XQThreeContentCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 三个内容 cell
class AC_XQThreeContentCell: AC_XQShadowCell {
    
    let topContentView = UIView()
    let centerContentView = UIView()
    let bottomContentView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.xq_contentView.xq_addSubviews(self.topContentView, self.centerContentView, self.bottomContentView)
        
        // 布局
        self.topContentView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        self.centerContentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.topContentView.snp.bottom)
            make.height.equalTo(96)
        }
        
        self.bottomContentView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.centerContentView.snp.bottom)
            make.bottom.equalToSuperview()
            make.height.equalTo(47)
        }
        
        // 设置属性
        
        self.centerContentView.backgroundColor = UIColor.init(hex: "#EFF2F2")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
