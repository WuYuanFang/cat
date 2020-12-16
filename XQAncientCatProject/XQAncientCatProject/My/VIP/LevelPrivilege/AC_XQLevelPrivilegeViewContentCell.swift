//
//  AC_XQLevelPrivilegeViewContentCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/11.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQLevelPrivilegeViewContentCell: UICollectionViewCell {
    
    let titleLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.titleLab)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        // 设置属性
        
        self.contentView.backgroundColor = UIColor.init(hex: "#D8E8E9")
        
        self.titleLab.textColor = UIColor.init(hex: "#2C5659")
        self.titleLab.font = UIFont.systemFont(ofSize: 13)
        self.titleLab.numberOfLines = 0
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
