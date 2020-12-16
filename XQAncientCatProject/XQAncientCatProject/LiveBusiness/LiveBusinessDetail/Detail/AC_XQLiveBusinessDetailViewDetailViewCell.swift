//
//  AC_XQLiveBusinessDetailViewDetailViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/5/27.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQLiveBusinessDetailViewDetailViewCell: AC_XQShadowCollectionViewCell {
    
    let imgView = UIImageView()
    let titleLab = UILabel()
    let messageLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_contentView.xq_addSubviews(self.imgView, self.titleLab, self.messageLab)
        
        // 布局
        
        let whScale = 123.0/107.0
        self.imgView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(self.imgView.snp.width).multipliedBy(1/whScale)
        }
        
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.imgView.snp.bottom).offset(3)
            make.left.equalTo(12)
            make.right.equalTo(-12)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(3)
            make.left.equalTo(12)
            make.right.equalTo(-12)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
        
        // 设置属性
        
        self.imgView.backgroundColor = UIColor.ac_mainColor
        
        self.titleLab.font = UIFont.systemFont(ofSize: 13)
        
        self.messageLab.font = UIFont.systemFont(ofSize: 13)
        self.messageLab.numberOfLines = 0
        self.messageLab.textColor = UIColor.init(hex: "#999999")
        
        
        self.titleLab.text = "参数"
        self.messageLab.text = "参数信息参数信息参数信息"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
