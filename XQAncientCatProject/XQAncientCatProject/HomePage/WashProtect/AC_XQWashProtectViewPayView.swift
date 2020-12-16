//
//  AC_XQWashProtectViewPayView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/1.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQWashProtectViewPayView: UIView {
    
    let moneyLab = UILabel()
    
    let payBtn = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.moneyLab, self.payBtn)
        
        // 布局
        self.moneyLab.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
        }
        
        self.payBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(58)
            make.width.equalTo(167)
        }
        
        // 设置属性
        
        self.moneyLab.textColor = UIColor.ac_mainColor
        self.moneyLab.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.payBtn.setTitle("下单", for: .normal)
        self.payBtn.backgroundColor = UIColor.ac_mainColor
        self.payBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        
//        self.moneyLab.text = "合计 ¥188"
        self.moneyLab.text = "合计 ¥"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.payBtn.xq_corners_addRoundedCorners(.topLeft, withRadii: .init(width: 25, height: 25))
    }

}
