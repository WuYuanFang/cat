//
//  XQSwitchRowView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/9.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class XQSwitchRowView: UIView {
    
    let titleLab = UILabel()
    let xq_switch = UISwitch()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.titleLab)
        self.addSubview(self.xq_switch)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.left.centerY.equalToSuperview()
        }
        
        self.xq_switch.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
        }
        
        // 设置属性
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 宽度自动适配
    /// - Parameter spacingBetweenTitleAndSwitch: 标题 和 switch 间距
    func widthAutoLayout(_ spacingBetweenTitleAndSwitch: CGFloat = 16) {
        self.titleLab.snp.remakeConstraints { (make) in
            make.left.centerY.equalToSuperview()
            make.right.equalTo(self.xq_switch.snp.left).offset(-spacingBetweenTitleAndSwitch)
        }
    }
    
}


