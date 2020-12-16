//
//  XQAlertSelectAppointmentViewFooterViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/8/14.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQPaddingLabel

class XQAlertSelectAppointmentViewFooterViewCell: UICollectionViewCell {
    
    var paddingLabel = XQPaddingLabel.init(frame: .zero, padding: .init(top: 8, left: 12, bottom: -8, right: -12), rounded: true)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.paddingLabel)
        
        // 布局
        self.paddingLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        // 设置属性
        self.paddingLabel.label.textColor = UIColor.ac_mainColor
        self.paddingLabel.label.textAlignment = .center
        self.paddingLabel.label.font = UIFont.systemFont(ofSize: 14)
        self.paddingLabel.label.text = "10:00"
        self.paddingLabel.backgroundColor = UIColor.clear
        self.paddingLabel.layer.borderColor = UIColor.ac_mainColor.cgColor
        
        self.paddingLabel.layer.shadowOffset = CGSize.init(width: 4, height: 4)
        self.paddingLabel.layer.shadowOpacity = 0
        self.paddingLabel.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
