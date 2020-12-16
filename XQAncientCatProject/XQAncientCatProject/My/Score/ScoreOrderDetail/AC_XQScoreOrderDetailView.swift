//
//  AC_XQScoreOrderDetailView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/8/3.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

class AC_XQScoreOrderDetailView: AC_XQFosterOrderViewBaseView {
    
    let headerView = AC_XQShopMallOrderViewHeaderView()
    
    let infoView = AC_XQScoreOrderDetailViewInfoView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.headerView, self.infoView)
        
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
            make.bottom.equalToSuperview().offset(-50)
        }
        
        
        // 设置属性
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}


class AC_XQScoreOrderDetailViewInfoView: AC_XQFosterOrderViewInfoViewBaseView {
    
    let productView = AC_XQShopMallOrderViewInfoViewCellContentView()
    
    /// 购买数量
    let buyNumberView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 运费
    let freightView = AC_XQFosterOrderViewInfoViewLabelView()
    
    /// 支付金额
    let moneyView = AC_XQFosterOrderViewInfoViewLabelView()
    
    
    /// 备注
    let remarkView = AC_XQFosterOrderViewInfoViewLabelView()
    
    /// 订单号
    let orderLab = UILabel()
    /// 复制
    let copyBtn = UIButton()
    /// 支付时间
    let payTimeLab = UILabel()
    
    
    let spacing: CGFloat = 12
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.productView, self.buyNumberView, self.freightView, self.moneyView, self.remarkView, self.orderLab, self.copyBtn, self.payTimeLab)
        
        
        // 布局
        self.productView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(12)
            make.right.equalTo(-20)
            make.height.equalTo(75)
        }
        
        self.buyNumberView.snp.makeConstraints { (make) in
            make.top.equalTo(self.productView.snp.bottom).offset(spacing)
            make.left.equalTo(self.productView)
            make.right.equalTo(self.productView)
        }
        
        self.freightView.snp.makeConstraints { (make) in
            make.top.equalTo(self.buyNumberView.snp.bottom).offset(spacing)
            make.left.equalTo(self.buyNumberView)
            make.right.equalTo(self.buyNumberView)
        }
        
        self.moneyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.freightView.snp.bottom).offset(spacing)
            make.left.equalTo(self.buyNumberView)
            make.right.equalTo(self.buyNumberView)
        }
        
        self.remarkView.snp.makeConstraints { (make) in
            make.top.equalTo(self.moneyView.snp.bottom).offset(spacing)
            make.left.equalTo(self.buyNumberView)
            make.right.equalTo(self.buyNumberView)
        }
        
        self.orderLab.snp.contentHuggingHorizontalPriority = UILayoutPriority.required.rawValue
        self.orderLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.remarkView.snp.bottom).offset(40)
            make.left.equalTo(self.buyNumberView)
            make.right.lessThanOrEqualToSuperview().offset(-60)
        }
        
        self.copyBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.orderLab)
            make.left.equalTo(self.orderLab.snp.right).offset(10)
        }
        
        self.payTimeLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.orderLab.snp.bottom).offset(5)
            make.left.equalTo(self.orderLab)
            make.bottom.equalTo(-30)
        }
        
        // 设置属性
        
        self.orderLab.font = UIFont.systemFont(ofSize: 13)
        self.orderLab.textColor = UIColor.init(hex: "#999999")
        
        self.payTimeLab.font = UIFont.systemFont(ofSize: 13)
        self.payTimeLab.textColor = UIColor.init(hex: "#999999")
        
        self.copyBtn.setTitle("复制", for: .normal)
        self.copyBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.copyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        self.copyBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if let str = self.orderLab.text?.components(separatedBy: " ").last {
                UIPasteboard.general.string = str
                SVProgressHUD.showSuccess(withStatus: "已复制")
            }
        }
        
        self.buyNumberView.titleLab.text = "购买数量"
        
        self.freightView.titleLab.text = "运费"
        self.freightView.contentLab.text = "包邮"
        
        self.moneyView.titleLab.text = "支付金额"
        
        self.remarkView.titleLab.text = "备注："
        
        self.buyNumberView.contentLab.text = "2"
        
        //        self.cancelOrderLab.text = "21小时45分03秒"
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
