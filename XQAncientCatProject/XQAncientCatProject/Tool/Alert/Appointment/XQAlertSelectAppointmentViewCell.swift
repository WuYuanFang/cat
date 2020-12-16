//
//  XQAlertSelectAppointmentViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/3.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQPaddingLabel

class XQAlertSelectAppointmentViewCell: UICollectionViewCell {
    
    let paddingLab = XQPaddingLabel.init(frame: .zero, padding: .init(top: 8, left: 10, bottom: -8, right: -10), rounded: true)
    
    /// 文字默认颜色
    var titleNormalColor = UIColor.ac_mainColor
    /// 背景默认颜色
    var backNormalColor = UIColor.clear
    
    private var _xq_select: Bool = false
    var xq_select: Bool {
        set {
            _xq_select = newValue
            
            if _xq_select {
                self.paddingLab.backgroundColor = UIColor.ac_mainColor
                self.paddingLab.label.textColor = UIColor.white
                self.paddingLab.layer.shadowOpacity = 0.15
            }else {
                self.paddingLab.backgroundColor = self.backNormalColor
                self.paddingLab.label.textColor = self.titleNormalColor
                self.paddingLab.layer.shadowOpacity = 0
            }
            
        }
        get {
            return _xq_select
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.paddingLab)
        
        // 布局
        
        self.paddingLab.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        // 设置属性
        
        self.paddingLab.label.textColor = UIColor.init(hex: "#999999")
        self.paddingLab.label.font = UIFont.systemFont(ofSize: 14)
        self.paddingLab.backgroundColor = UIColor.clear
        
        self.paddingLab.label.text = "10:00"
        
        self.paddingLab.layer.shadowOffset = CGSize.init(width: 4, height: 4)
        self.paddingLab.layer.shadowOpacity = 0
        self.paddingLab.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
