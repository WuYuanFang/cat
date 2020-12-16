//
//  AC_XQShopMallOrderViewPayView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/18.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQShopMallOrderViewPayView: UIView {

    let moneyLab = UILabel()
    
    let payBtn = AC_XQSideButtonView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.moneyLab, self.payBtn)
        
        // 布局
        self.moneyLab.snp.makeConstraints { (make) in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
        }
        
        self.payBtn.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.bottom.equalTo(-10)
            make.right.equalToSuperview()
            make.width.equalTo(167)
        }
        
        // 设置属性
        
        self.moneyLab.textColor = UIColor.ac_mainColor
        self.moneyLab.font = UIFont.boldSystemFont(ofSize: 18)
        
        self.payBtn.titleLab.text = "下单"
        
//        self.moneyLab.text = "合计 ¥188"
        self.moneyLab.text = "合计 ¥"
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }

}
