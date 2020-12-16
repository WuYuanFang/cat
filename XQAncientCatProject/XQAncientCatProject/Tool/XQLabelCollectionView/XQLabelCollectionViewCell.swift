//
//  XQLabelCollectionViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/5.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class XQLabelCollectionViewCell: UICollectionViewCell {
    
    let titleLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.titleLab)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(8)
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-8)
        }
        
        
        // 设置属性
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
