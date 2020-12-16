//
//  AC_XQSetViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQSetViewCell: UITableViewCell {
    
    let titleLab = UILabel()
    let messageLab = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.xq_addSubviews(self.titleLab, self.messageLab)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(16)
            make.bottom.equalTo(-16)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.right.equalTo(-12)
            make.centerY.equalToSuperview()
        }
        
        // 设置属性
        
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        self.messageLab.font = UIFont.systemFont(ofSize: 16)
        self.messageLab.textColor = UIColor.init(hex: "#666666")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
