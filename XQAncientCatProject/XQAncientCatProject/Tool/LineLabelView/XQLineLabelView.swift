//
//  XQLineLabelView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/15.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 左边有一条线的 label
class XQLineLabelView: UIView {
    
    let lineView = UIView()
    
    let titleLab = UILabel()
    
    init(frame: CGRect, lineWidth: CGFloat = 3, lineColor: UIColor = UIColor.orange, lineToLabelSpacing: CGFloat = 6) {
        super.init(frame: frame)
        
        
        self.xq_addSubviews(self.lineView, self.titleLab)
        
        // 布局
        
        self.lineView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(lineWidth)
        }
        
        self.titleLab.snp.makeConstraints { (make) in
            make.left.equalTo(self.lineView.snp.right).offset(lineToLabelSpacing)
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        // 设置属性
        self.lineView.backgroundColor = lineColor
        self.lineView.layer.cornerRadius = lineWidth/2
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
