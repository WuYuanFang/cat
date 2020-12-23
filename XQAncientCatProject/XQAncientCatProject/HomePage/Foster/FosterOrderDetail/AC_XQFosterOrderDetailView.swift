//
//  AC_XQFosterOrderDetailView.swift
//  XQAncientCatProject
//
//  Created by WXQ on 2020/7/17.
//  Copyright © 2020 WXQ. All rights reserved.
//

import UIKit
import SVProgressHUD

class AC_XQFosterOrderDetailView: AC_XQFosterOrderViewBaseView {

    let headerView = AC_XQFosterOrderViewHeaderView()
    
    let infoView = AC_XQFosterOrderDetailViewInfoView()
    
    let bottomView = AC_XQWashProtectOrderDetailViewBottomView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.xq_addSubviews(self.headerView, self.infoView, self.bottomView)
        
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
        
        self.bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self.infoView.snp.bottom).offset(25)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
        
        
        // 设置属性
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


class AC_XQFosterOrderDetailViewInfoView: AC_XQFosterOrderViewInfoViewBaseView {
    
    /// 套餐服务
    let serverView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 预约时间
    let timeView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 天数
    let dayView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 会员抵扣
    let vipZKView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 支付金额
    let moneyView = AC_XQFosterOrderViewInfoViewLabelView()
    
    /// 取消订单
    let cancelOrderBtn = UIButton()
    /// 申请退款 / 去付款
    let payOrReservedBtn = UIButton()
    /// 取消订单
    let cancelOrderLab = UILabel()
    
    /// 手机号
    let phoneView = AC_XQFosterOrderViewInfoViewLabelView()
    /// 姓名
    let nameView = AC_XQFosterOrderViewInfoViewLabelView()
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
        
        self.contentView.xq_addSubviews(self.serverView, self.timeView, self.dayView, self.vipZKView, self.moneyView, self.payOrReservedBtn, self.cancelOrderBtn, self.cancelOrderLab, self.phoneView, self.nameView, self.remarkView, self.orderLab, self.copyBtn, self.payTimeLab)
        
        
        // 布局
        self.serverView.snp.makeConstraints { (make) in
            make.top.equalTo(12)
            make.left.equalTo(12)
            make.right.equalTo(-20)
        }
        
        self.timeView.snp.makeConstraints { (make) in
            make.top.equalTo(self.serverView.snp.bottom).offset(spacing)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.dayView.snp.makeConstraints { (make) in
            make.top.equalTo(self.timeView.snp.bottom).offset(spacing)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.vipZKView.snp.makeConstraints { (make) in
            make.top.equalTo(self.dayView.snp.bottom).offset(40)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.moneyView.snp.makeConstraints { (make) in
            make.top.equalTo(self.vipZKView.snp.bottom).offset(spacing)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.payOrReservedBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.moneyView.snp.bottom).offset(20)
            make.right.equalTo(self.serverView)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        self.cancelOrderBtn.snp.makeConstraints { (make) in
            make.top.equalTo(payOrReservedBtn)
            make.right.equalTo(self.payOrReservedBtn.snp.left).offset(-12)
            make.size.equalTo(CGSize.init(width: 80, height: 30))
        }
        
        self.cancelOrderLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.cancelOrderBtn)
            make.right.equalTo(self.cancelOrderBtn.snp.left).offset(-5)
        }
        
        self.phoneView.snp.makeConstraints { (make) in
            make.top.equalTo(self.cancelOrderBtn.snp.bottom).offset(20)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.nameView.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneView.snp.bottom).offset(spacing)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.remarkView.snp.makeConstraints { (make) in
            make.top.equalTo(self.nameView.snp.bottom).offset(spacing)
            make.left.equalTo(self.serverView)
            make.right.equalTo(self.serverView)
        }
        
        self.orderLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.remarkView.snp.bottom).offset(40)
            make.left.equalTo(self.serverView)
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
        
        self.payOrReservedBtn.setTitle("去付款", for: .normal)
        self.payOrReservedBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.payOrReservedBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.payOrReservedBtn.layer.cornerRadius = 15
        self.payOrReservedBtn.layer.borderWidth = 1
        self.payOrReservedBtn.layer.borderColor = UIColor.ac_mainColor.cgColor
        
        self.cancelOrderBtn.setTitle("取消订单", for: .normal)
        self.cancelOrderBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.cancelOrderBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.cancelOrderBtn.layer.cornerRadius = 15
        self.cancelOrderBtn.layer.borderWidth = 1
        self.cancelOrderBtn.layer.borderColor = UIColor.ac_mainColor.cgColor
        
        self.cancelOrderLab.font = UIFont.systemFont(ofSize: 13)
        self.cancelOrderLab.textColor = UIColor.ac_mainColor
        
        self.copyBtn.setTitle("复制", for: .normal)
        self.copyBtn.setTitleColor(UIColor.ac_mainColor, for: .normal)
        self.copyBtn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        
        self.copyBtn.xq_addEvent(.touchUpInside) { [unowned self] (sender) in
            if let str = self.orderLab.text?.components(separatedBy: " ").last {
                UIPasteboard.general.string = str
                SVProgressHUD.showSuccess(withStatus: "已复制")
            }
        }
        
        self.serverView.titleLab.text = "服务项目"
        self.serverView.desLab.text = "寄养"
        
        self.timeView.titleLab.text = "预约时间"
        
        self.dayView.titleLab.text = "寄养天数"
        
        self.vipZKView.titleLab.text = "会员折扣"
        
        self.moneyView.titleLab.text = "支付金额"
        
        self.phoneView.titleLab.text = "手机号："
        self.nameView.titleLab.text = "联系人："
        self.remarkView.titleLab.text = "备注："
        
        
        self.serverView.contentLab.text = "¥188/天"
        self.timeView.contentLab.text = "3月14日 20:00"
        self.dayView.contentLab.text = "5天"
        
//        self.cancelOrderLab.text = "21小时45分03秒"
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}


