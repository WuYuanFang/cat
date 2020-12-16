//
//  AC_XQShopRefundOrderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/9/10.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import UITextView_Placeholder
import XQUITextField_Navigation

class AC_XQShopRefundOrderView: AC_XQFosterOrderViewBaseView {
    
    let headerView = AC_XQShopMallOrderViewInfoViewCellContentView()
    
    let payTimeView = AC_XQShopRefundOrderViewLabelView()
    
    let orderView = AC_XQShopRefundOrderViewLabelView()
    
    let moneyView = AC_XQShopRefundOrderViewLabelView()
    
    let reasonView = AC_XQShopRefundOrderViewTextView()
    
    let commitBtn = UIButton()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.headerView, self.payTimeView, self.orderView, self.moneyView, self.reasonView, self.commitBtn)
        
        // 布局
        self.headerView.snp.makeConstraints { (make) in
//            make.top.equalTo(20)
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(90)
        }
        
        self.payTimeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        self.orderView.snp.makeConstraints { (make) in
            make.top.equalTo(self.payTimeView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        self.moneyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.orderView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        self.reasonView.snp.makeConstraints { (make) in
            make.top.equalTo(self.moneyView.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }
        
        self.commitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.reasonView.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
            make.bottom.equalToSuperview()
        }
        
        
        
        // 设置属性
        self.contentView.backgroundColor = UIColor.init(hex: "#F4F4F4")
        
        self.headerView.backgroundColor = UIColor.white
        
        self.payTimeView.titleLab.text = "支付时间: "
        self.payTimeView.messageLab.text = " "
        
        self.orderView.titleLab.text = "订单号: "
        self.orderView.messageLab.text = " "
        
        self.moneyView.titleLab.text = "退款金额: "
        self.moneyView.messageLab.text = " "
        self.moneyView.messageLab.textColor = UIColor.red
        
        self.reasonView.titleLab.text = "退款原因: "
        self.reasonView.tv.placeholder = "请添加退款原因描述"
        
        self.commitBtn.backgroundColor = UIColor.ac_mainColor
        self.commitBtn.setTitle("提交", for: .normal)
        
        self.xq_showTextField_Navigation()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class AC_XQShopRefundOrderViewLabelView: UIView {
    
    let titleLab = UILabel()
    let messageLab = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab, self.messageLab)
        
        // 布局
//        self.titleLab.snp.contentCompressionResistanceHorizontalPriority = UILayoutPriority.required.rawValue
        self.titleLab.snp.contentHuggingHorizontalPriority = UILayoutPriority.required.rawValue
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(16)
        }
        
        self.messageLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab)
            make.left.equalTo(self.titleLab.snp.right).offset(5)
            make.right.equalTo(-16)
            make.bottom.equalTo(-16)
        }
        
        // 设置属性
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
        self.messageLab.font = UIFont.systemFont(ofSize: 16)
        self.messageLab.numberOfLines = 0
        
        self.backgroundColor = UIColor.white
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}



class AC_XQShopRefundOrderViewTextView: UIView {
    
    let titleLab = UILabel()
    let tv = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.xq_addSubviews(self.titleLab, self.tv)
        
        // 布局
        self.titleLab.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.equalTo(16)
        }
        
        self.tv.snp.makeConstraints { (make) in
            make.top.equalTo(self.titleLab.snp.bottom).offset(12)
            make.left.right.equalTo(self.titleLab)
            make.right.equalTo(-16)
            make.bottom.equalTo(-16)
            make.height.equalTo(200)
        }
        
        // 设置属性
        
        self.backgroundColor = UIColor.white
        self.titleLab.font = UIFont.systemFont(ofSize: 16)
        
        self.tv.font = UIFont.systemFont(ofSize: 16)
        self.tv.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.tv.layer.cornerRadius = 10
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
