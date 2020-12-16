//
//  AC_XQMyIncomeView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import QMUIKit

class AC_XQMyIncomeView: UIView {
    
    let titleLab = UILabel()
    let moneyLab = UILabel()
    let detailBtn = QMUIButton()
    
    let withdrawalBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab, self.moneyLab, self.detailBtn, self.withdrawalBtn)
        
        // 布局
        
        self.titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().multipliedBy(0.3)
            make.centerX.equalToSuperview()
        }
        
        self.moneyLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }
        
        self.detailBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.moneyLab.snp.bottom).offset(15)
            make.centerX.equalToSuperview()
        }
        
        self.withdrawalBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().multipliedBy(1.3)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 162, height: 44))
        }
        
        // 设置属性
        
        self.titleLab.text = "我的收入（元）"
        self.titleLab.font = UIFont.systemFont(ofSize: 17)
        
        self.moneyLab.text = "0"
        self.moneyLab.font = UIFont.boldSystemFont(ofSize: 24)
        
        self.detailBtn.setTitle("查看明细 >", for: .normal)
        self.detailBtn.setTitleColor(UIColor.init(hex: "#999999"), for: .normal)
        self.detailBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.withdrawalBtn.setTitle("立即提现", for: .normal)
        self.withdrawalBtn.backgroundColor = UIColor.ac_mainColor
        self.withdrawalBtn.layer.cornerRadius = 10
        self.withdrawalBtn.layer.shadowColor = UIColor.black.cgColor
        self.withdrawalBtn.layer.shadowOpacity = 0.2
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
