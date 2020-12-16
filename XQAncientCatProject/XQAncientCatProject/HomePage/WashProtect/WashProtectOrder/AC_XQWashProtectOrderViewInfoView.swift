//
//  AC_XQWashProtectOrderViewInfoView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/19.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQWashProtectOrderViewInfoView: AC_XQFosterOrderViewInfoViewBaseView {
    
    /// 套餐服务
    let serverView = AC_XQWashProtectOrderViewInfoViewLabelView()
    /// 预约时间
    let timeView = AC_XQFosterOrderViewInfoViewLabelView()
    
    /// 预计结束时间
    let endTimeView = AC_XQFosterOrderViewInfoViewLabelView()
    
    let spacing: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.serverView, self.timeView, self.endTimeView)
        
        
        // 布局
        self.serverView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(12)
            make.right.equalTo(-20)
        }
        
        self.timeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.serverView.snp.bottom).offset(20)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.endTimeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.timeView.snp.bottom).offset(20)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
            make.bottom.equalTo(-30)
        }
        
        // 设置属性
        
        self.serverView.titleLab.text = "服务项目"
        self.serverView.desLab.text = "高级精致洗护套餐"
        self.serverView.desDetailLab.text = "高级美容*1\n高级美容*1"
        self.serverView.contentLab.text = "¥188"
        
        self.timeView.titleLab.text = "预约时间"
        self.timeView.contentLab.text = "3月14日 20:00"
        
        self.endTimeView.titleLab.text = "预计结束时间"
        self.endTimeView.contentLab.text = "3月14日 20:00"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}


class AC_XQWashProtectOrderViewInfoViewLabelView: UIView {
    
    /// 标题
    let titleLab = UILabel()
    
    /// 套餐
    let desLab = UILabel()
    
    /// 单品
    let desDetailLab = UILabel()
    
    /// 最右边
    let contentLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.xq_addSubviews(self.titleLab, self.desLab, self.desDetailLab, self.contentLab)
        
        // 布局
        self.titleLab.snp.contentHuggingHorizontalPriority = UILayoutPriority.required.rawValue
        self.titleLab.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        self.desLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(self.titleLab.snp.right).offset(12)
            make.right.equalTo(self.contentLab.snp.left).offset(12)
        }
        
        self.desDetailLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.desLab.snp.bottom).offset(8)
            make.left.equalTo(self.titleLab.snp.right).offset(12)
            make.right.equalTo(self.contentLab.snp.left).offset(12)
            make.bottom.equalToSuperview()
        }
        
        self.contentLab.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
        }
        
        
        // 设置属性
        self.titleLab.font = UIFont.systemFont(ofSize: 14)
        self.titleLab.textAlignment = .left
        
        self.desLab.font = UIFont.systemFont(ofSize: 14)
        self.desLab.textAlignment = .left
        
        self.desDetailLab.font = UIFont.systemFont(ofSize: 13)
        self.desDetailLab.textColor = UIColor.init(hex: "#666666")
        self.desDetailLab.textAlignment = .left
        self.desDetailLab.numberOfLines = 0
        
        self.contentLab.font = UIFont.systemFont(ofSize: 14)
        self.contentLab.textAlignment = .right
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
