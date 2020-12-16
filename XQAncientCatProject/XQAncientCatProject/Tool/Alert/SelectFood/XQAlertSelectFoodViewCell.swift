//
//  XQAlertSelectFoodViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/17.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class XQAlertSelectFoodViewCell: UICollectionViewCell {
    
    let btn = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.btn)
        
        // 布局
        
        self.btn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 设置属性
        
        self.btn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        self.btn.setTitleColor(UIColor.ac_mainColor, for: .selected)
        self.btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.btn.titleLabel?.textAlignment = .center
        self.btn.isUserInteractionEnabled = false
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
