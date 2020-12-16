//
//  AC_XQWashProtectViewPackageView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/30.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

/// 服务view
class AC_XQWashProtectViewServiceView: UIView {
    
    /// 套餐
    let packageBtn = AC_XQCommodityDetailViewContentViewBtn()
    
    /// 单项
    let singleBtn = AC_XQCommodityDetailViewContentViewBtn()
    
    
    /// 套餐view
    let contentView = AC_XQWashProtectViewServiceViewContentView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.packageBtn, self.singleBtn, self.contentView)
        
        // 布局
        self.packageBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(12)
        }
        
        self.singleBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.packageBtn)
            make.left.equalTo(self.packageBtn.snp.right).offset(20)
        }
        
        self.contentView.snp.makeConstraints { (make) in
            make.top.equalTo(self.packageBtn.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // 设置属性
        self.configBtn(self.packageBtn, title: "套餐服务")
        self.configBtn(self.singleBtn, title: "单项服务")
        
        self.packageBtn.isSelected = true
        
        self.packageBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if sender?.isSelected ?? false == true {
                return
            }
            
            self.packageBtn.isSelected.toggle()
            self.singleBtn.isSelected.toggle()
        }
        
        self.singleBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if sender?.isSelected ?? false == true {
                return
            }
            
            self.packageBtn.isSelected.toggle()
            self.singleBtn.isSelected.toggle()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configBtn(_ btn: AC_XQCommodityDetailViewContentViewBtn, title: String) {
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        btn.setTitleColor(UIColor.black, for: .selected)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.lineHeight = 1
        btn.setLineBackColor(UIColor.clear, for: .normal)
        btn.setLineBackColor(UIColor.ac_mainColor, for: .selected)
        btn.isSelected = false
    }
    
    
}
