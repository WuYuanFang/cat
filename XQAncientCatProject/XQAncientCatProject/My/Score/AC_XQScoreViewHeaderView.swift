//
//  AC_XQScoreViewHeaderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/6/12.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQScoreViewHeaderView: UIView {
    
    /// 积分
    let currentScoreLab = UILabel()
    /// 可扣钱
    let moneyLab = UILabel()
    /// 签到
    let signInBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.currentScoreLab, self.moneyLab, self.signInBtn)
        
        // 布局
        self.currentScoreLab.snp.makeConstraints { (make) in
            make.top.equalTo(105)
            make.centerX.equalToSuperview()
        }
        
        self.moneyLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.currentScoreLab.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        self.signInBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.moneyLab.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 116, height: 30))
            make.bottom.equalTo(-50)
        }
        
        
        // 设置属性
        self.backgroundColor = UIColor.ac_mainColor
        
        self.signInBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.signInBtn.setTitle("签到领积分", for: .normal)
        self.signInBtn.backgroundColor = UIColor.white
        self.signInBtn.layer.cornerRadius = 15
        self.signInBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        self.currentScoreLab.textColor = UIColor.white
        self.currentScoreLab.font = UIFont.systemFont(ofSize: 16)
        
        self.moneyLab.textColor = UIColor.white
        self.moneyLab.font = UIFont.systemFont(ofSize: 13)
        
        self.currentScoreLab.text = "当前22积分"
        self.moneyLab.text = "可抵扣2.2元"
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
