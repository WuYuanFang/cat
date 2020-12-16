//
//  AC_XQShopMallOrderView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/18.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit

class AC_XQShopMallOrderView: AC_XQFosterOrderViewBaseView {
    
    let headerView = AC_XQShopMallOrderViewHeaderView()
    
    /// 支付
    let payView = AC_XQShopMallOrderViewPayView()
    
    /// 中间信息
    let infoView = AC_XQShopMallOrderViewInfoView()
    
    /// 会员专享
    let vipView = AC_XQFosterOrderViewVIPSelectRowView()
    
    /// 实名认证专享
    let rnDiscountView = AC_XQFosterOrderViewRealNameDiscountSelectRowView()
    
    /// 优惠券
    let couponView = AC_XQFosterOrderViewCouponView()
    
    /// 备注
    let remarkLab = UILabel()
    let remarkTV = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        self.contentView.xq_addSubviews(self.payView, self.headerView, self.infoView, self.vipView, self.rnDiscountView, self.couponView, self.remarkLab, self.remarkTV)
        
        // 布局
        
        self.headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(30)
            make.left.equalTo(16)
            make.right.equalTo(-16)
        }
        
        self.infoView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerView.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalTo(-12)
        }
        
        self.vipView.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoView.snp.bottom).offset(20)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(30)
        }
        
        self.rnDiscountView.snp.makeConstraints { (make) in
            make.top.equalTo(self.vipView.snp.bottom).offset(6)
            make.left.equalTo(self.vipView)
            make.right.equalTo(self.vipView)
            make.height.equalTo(30)
        }
        
        self.couponView.snp.makeConstraints { (make) in
            make.top.equalTo(self.rnDiscountView.snp.bottom).offset(6)
            make.left.equalTo(self.rnDiscountView)
            make.right.equalTo(self.rnDiscountView)
            make.height.equalTo(30)
        }
        
        self.remarkLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.couponView.snp.bottom).offset(25)
            make.left.equalTo(self.vipView)
        }
        
        self.remarkTV.snp.makeConstraints { (make) in
            make.top.equalTo(self.remarkLab)
            make.left.equalTo(self.remarkLab.snp.right).offset(16)
            make.right.equalTo(self.vipView)
            make.height.equalTo(80)
        }
        
        self.payView.snp.makeConstraints { (make) in
            make.top.greaterThanOrEqualTo(self.remarkTV.snp.bottom).offset(30)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(-25)
        }
        
        
        
        // 设置属性
        
        self.remarkLab.text = "备注："
        self.remarkLab.font = UIFont.systemFont(ofSize: 14)
        self.remarkTV.placeholder = "亲亲可以在这里备注哦"
        self.remarkTV.backgroundColor = UIColor.init(hex: "#F4F4F4")
        self.remarkTV.layer.cornerRadius = 4
        
        
        self.payView.payBtn.titleLab.text = "确认下单"
        self.payView.moneyLab.textColor = UIColor.black
        
        self.xq_showTextField_Navigation()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
