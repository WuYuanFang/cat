//
//  XQAlertSelectFoodViewDetailViewCell.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/17.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import XQPaddingLabel

class XQAlertSelectFoodViewDetailViewCell: UICollectionViewCell {
    
    let paddingView = XQPaddingLabel.init(frame: .zero, padding: .init(top: 8, left: 12, bottom: -8, right: -12), rounded: true)
    
    private var _xq_select: Bool = false
    var xq_select: Bool {
        set {
            _xq_select = newValue
            
            if _xq_select {
                self.paddingView.label.textColor = UIColor.white
                self.paddingView.backgroundColor = UIColor.ac_mainColor
                self.paddingView.layer.shadowOpacity = 0.15
            }else {
                self.paddingView.label.textColor = UIColor.ac_mainColor
                self.paddingView.backgroundColor = UIColor.clear
                self.paddingView.layer.shadowOpacity = 0
            }
            
        }
        get {
            return _xq_select
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.addSubview(self.paddingView)
        
        // 布局
        
        self.paddingView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
//            make.left.equalTo(8)
//            make.right.equalTo(-8)
            make.left.right.equalToSuperview()
        }
        
        // 设置属性
        
        self.xq_select = false
        self.paddingView.label.font = UIFont.systemFont(ofSize: 14)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
